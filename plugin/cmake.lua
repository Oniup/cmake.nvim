local cmake = require("cmake")
local utils = require("cmake.utils")

vim.api.nvim_create_user_command("CMake", function()
  cmake.generate()
end, {})

vim.api.nvim_create_user_command("CMakeBuild", function()
  cmake.build()
end, {})

vim.api.nvim_create_user_command("CMakeSelectKit", function(opts)
  if cmake.select_kit(opts.args) then
    local title = cmake.__selected_kit.name
    if title == nil then
      title = "of type " .. cmake.__selected_kit.type
    end
    utils.log_info("Selected kit " .. title)
  end
end, { nargs = 1 })

vim.api.nvim_create_user_command("CMakeSelectKitOfType", function(opts)
  if cmake.select_kit(opts.args, true) then
    local title = cmake.__selected_kit.name
    if title == nil then
      title = "of type " .. cmake.__selected_kit.type
    end
    utils.log_info("Selected kit " .. title)
  end
end, { nargs = 1 })

vim.api.nvim_create_user_command("CMakePrintPluginOptions", function()
  print(vim.inspect(cmake.__opts))
end, {})
