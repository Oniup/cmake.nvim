local cmake = require("cmake")
local utils = require("cmake.utils")

vim.api.nvim_create_user_command("CMake", cmake.generate, {})

vim.api.nvim_create_user_command("CMakeBuild",
  cmake.build, {})

vim.api.nvim_create_user_command("CMakeRun", function()
  cmake.run()
end, {})

vim.api.nvim_create_user_command("CMakeBuildTargets", cmake.build_targets, {})

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

vim.api.nvim_create_user_command("CMakeSelectBuildTarget", function(opts)
  cmake.select_build_target(opts.args)
end, { nargs = 1 })
