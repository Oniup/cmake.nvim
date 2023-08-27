local M = {}

local fill_os_based_missing = function(opts, key, vwin, vunix)
  if opts[key] == nil then
    if vim.fn.has("win32") then
      opts[key] = vwin
    else
      opts[key] = vunix
    end
  end
end

local fill_missing = function(opts)
  for k, v in pairs(M.default_opts) do
    if opts[k] == nil then
      opts[k] = v
    end
  end

  fill_os_based_missing(opts, "generator", "Ninja", "Make")

  return opts
end

M.default_opts = {
  -- Common
  executable = "cmake",
  reload_after_save = false,
  enable_compile_commands = false,
  vimspector_support = false,
  extra_opts = {},

  -- Build path
  --
  build_type = "Debug",
  build_directory_prefix = "cmake-build-",
  kits_path = nil, -- NOTE: CMake kits are not supported yet

  vimspector_default_opts = nil
}

M.opts = {} -- User defined opts

M.set_opts = function(opts)
  M.opts = fill_missing(opts)
end

return M
