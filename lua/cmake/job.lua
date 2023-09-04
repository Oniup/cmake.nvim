local utils = require("cmake.utils")

local bufnr = -1
local job = {}
job.output = {}

function job.setup(show_command, auto_scrolling)
  job.__show_command = show_command
  job.__auto_scrolling = auto_scrolling
end

--- @param start_pos integer
--- @param end_pos integer
--- @param lines table of strings, each new entry will be appended to the next line
--- @param ignore_empty_lines boolean|nil
function job.buffer_add_lines(start_pos, end_pos, lines, ignore_empty_lines)
  if ignore_empty_lines == nil then
    ignore_empty_lines = false
  end
  local pushing = {}
  for _, v in ipairs(lines) do
    local skip = false
    if ignore_empty_lines then
      if #v < 1 then
        skip = true
      end
    end
    if not skip then
      v = string.gsub(v, "[%c]", "")
      table.insert(pushing, v)
    end
  end
  vim.api.nvim_buf_set_option(bufnr, "readonly", false)
  vim.api.nvim_buf_set_lines(bufnr, start_pos, end_pos, true, pushing)
  vim.api.nvim_buf_set_option(bufnr, "readonly", true)
  vim.api.nvim_buf_set_option(bufnr, "modified", false)

  if job.__auto_scrolling then
    local window = vim.api.nvim_get_current_win()
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    vim.api.nvim_win_set_cursor(window, { line_count, 0 })
  end
end

function job.buffer_is_open()
  local is_visable = vim.api.nvim_call_function("bufwinnr",
    { bufnr }) ~= -1
  if bufnr == -1 or not is_visable then
    return false
  end
  return true
end

--- @param clear boolean | nil
function job.open_split(message, clear)
  if not job.buffer_is_open() then
    vim.cmd("botright split")
    local handle = vim.api.nvim_tabpage_get_win(0)
    bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(handle, bufnr)
  end

  vim.api.nvim_buf_set_option(bufnr, "readonly", false)
  local writting_pos = -1
  if clear == nil or clear then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, {})
    writting_pos = 0
  end
  if message ~= nil then
    local lines = message
    if type(message) ~= "table" then
      lines = { message }
    end
    vim.api.nvim_buf_set_lines(bufnr, writting_pos, -1, true, lines)
  end
  vim.api.nvim_buf_set_option(bufnr, "readonly", true)
  vim.api.nvim_buf_set_option(bufnr, "modified", false)
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "delete")
end

--- @param title string | nil if nil, then there will be no title printed
--- @param commands table
--- @param index integer | nil
function job.run_in_split(title, commands, index)
  local function append_lines(_, data)
    if data then
      job.buffer_add_lines(-1, -1, data, true)
    end
  end

  local clear = true
  if index == nil then
    index = 1
  else
    if commands[index].clear ~= nil then
      clear = commands[index].clear
    else
      clear = false
    end
  end

  job.open_split(title, clear)
  if job.__show_command then
    job.buffer_add_lines(-1, -1, {
      "cmd:", "  " .. utils.list_to_string(commands[index]), "output:" })
  else
    job.buffer_add_lines(-1, -1, { "output:" })
  end

  vim.fn.jobstart(commands[index], {
    on_stdout = append_lines,
    on_stderr = append_lines,
    on_exit = function(_, result)
      job.buffer_add_lines(-1, -1, { "Exited with code: " .. result, "" })
      if result == 0 then
        index = index + 1
        if commands[index] ~= nil then
          job.run_in_split(nil, commands, index)
        end
      end
    end,
  })
end

return job
