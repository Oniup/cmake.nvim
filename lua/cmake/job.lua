local utils = require("cmake.utils")

local bufnr = -1
local job = {}
job.output = {}

function job.open_split(message)
  local is_visable = vim.api.nvim_call_function("bufwinnr", { bufnr }) ~= -1
  if bufnr == -1 or not is_visable then
    vim.cmd([[botright split cmake-output]])
    local handle = vim.api.nvim_tabpage_get_win(0)
    bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(handle, bufnr)
  end

  vim.api.nvim_buf_set_option(bufnr, "readonly", false)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, {}) -- Clear buffer
  if message ~= nil then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1 + 2, true, message)
  end
  vim.api.nvim_buf_set_option(bufnr, "readonly", true)
  vim.api.nvim_buf_set_option(bufnr, "modified", false)
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "delete")
end

function job.append_line_into_buffer(_, data)
  if data then
    vim.api.nvim_buf_set_option(bufnr, "readonly", false)
    for _, v in ipairs(data) do
      if #v > 0 then
        v = v:gsub('[%c]', '')
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, true, { v })
      end
    end
    vim.api.nvim_buf_set_option(bufnr, "readonly", true)
    vim.api.nvim_buf_set_option(bufnr, "modified", false)
  end
end

function job.run_in_split(command)
  job.open_split({ utils.list_to_string(command), "Output:" })
  vim.fn.jobstart(command, {
    -- stdout_buffered = true,
    -- stderr_buffered = true,
    on_stdout = job.append_line_into_buffer,
    on_stderr = job.append_line_into_buffer
  })
end

return job