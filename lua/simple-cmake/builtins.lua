local config = require("simple-cmake.config")
local log = require("simple-cmake.log")

local target_bufnr = -1

local function open_buffer(title)
  -- Check if the buffer is visible
  local buffer_visible = vim.api.nvim_call_function("bufwinnr", { target_bufnr }) ~= -1
  if target_bufnr == -1 or not buffer_visible then
    -- Create buffer
    vim.api.nvim_command("botright vsplit CMake Output")
    target_bufnr = vim.api.nvim_get_current_buf()
  end
end

local function append_log(_, data)
  if data then
    vim.api.nvim_buf_set_option(target_bufnr, "readonly", false)
    vim.api.nvim_buf_set_lines(target_bufnr, -1, -1, true, data)
    vim.api.nvim_buf_set_option(target_bufnr, "readonly", true)
    vim.api.nvim_buf_set_option(target_bufnr, "modified", false) -- Stop Neovim complaining when trying to close

    -- Setting the cursor position to the bottom
    local buffer_window = vim.api.nvim_call_function("bufwind", { target_bufnr })
    local buffer_line_count = vim.api.nvim_buf_line_count(target_bufnr)
    vim.api.nvim_win_set_cursor(buffer_window, { buffer_line_count, 0 })
  end
end

local function run_cmd(commands)
  open_buffer()
  vim.api.nvim_buf_set_lines(target_bufnr, 0, -1, true, {});
  local last_job = nil
  for i = 0, #commands do

    last_job = vim.fn.jobstart(commands[i], {
      stdout_buffered = true,
      on_stdout = append_log,
      on_stderr = append_log,
      on_stdend = last_job
    })
  end
end

local M = {}

function M.get_generate_command(args)
  local function bool_to_int(value)
    return value and 1 or 0
  end

  local command = {
    args["executable"],
    "-G",
    args["generator"],
    "-S",
    ".",
    "-B",
    args["build_directory_prefix"] .. args["build_type"],
    "-DCMAKE_BUILD_TYPE=" .. args["build_type"],
    "-DCMAKE_EXPORT_COMPILE_COMMANDS=" .. bool_to_int(args["enable_compile_commands"]),
  }

  for i = 1, #args.extra_opts do
    table.insert(command, "-D" .. args.extra_opts[i])
  end

  return command
end

function M.generate()
  M.generate_buf_with_args(config.opts)
end

-- cmake -GNinja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1
-- -S . -B .\cmake-build-debug
function M.generate_buf_with_args(args)
  run_cmd(M.get_generate_command(args))
end

-- ninja -C .\cmake-build-debug
function M.build_buf_with_args(args)
  -- TODO: ...
end

return M;
