local config = require("simple-cmake.config")
local builtins = require("simple-cmake.builtins")

local M = {}

M.setup = function(opts)
  config.set_opts(opts)
end

vim.api.nvim_create_user_command("CMakeShowConfig", function()
  print(vim.inspect(config.opts))
end, {})

vim.api.nvim_create_user_command("CMakeShowGenerateCommand", function()
  print(vim.inspect(builtins.get_generate_command(config.opts)))
end, {})

vim.api.nvim_create_user_command("CMakeGenerate", builtins.generate, {})

return M
