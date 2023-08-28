local utils = require("cmake.utils")
local buffer = require("cmake.buffer")

local cmake = {}

function cmake.setup(opts)
  local default = require("cmake.default")
  utils.table_fill_missing(opts, default)
  cmake.__opts = opts
end

vim.api.nvim_create_user_command("CMake", function()
  local command = { "cmake", "-G", "Ninja", "-S", ".", "-B", "cmake-build-Debug",
    "-DCMAKE_BUILD_TYPE=Debug", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }
  buffer.open_split({
    "Command:", utils.list_to_string(command), "", "Output:" })
end, {})

vim.api.nvim_create_user_command("CMakePrintPluginOptions", function()
  print(vim.inspect(cmake.__opts))
end, {})

return cmake
