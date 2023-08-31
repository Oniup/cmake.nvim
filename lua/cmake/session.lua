local utils = require("cmake.utils")
local Path = require("plenary.path")

local session = {}
session.__opts = {}

function session.set_opts(opts)
  session.__opts = opts
end

function session.get_cache_root()
  if vim.fn.has("win32") then
    return session.__opts.dir.win32
  else
    return session.__opts.dir.unix
  end
end

function session.get_cache()
  local path = vim.loop.cwd()
  if path then
    local clean_path = path:gsub("/", "")
    clean_path = clean_path:gsub("\\", "")
    clean_path = clean_path:gsub(":", "")
    return session.get_cache_root() .. clean_path .. ".lua"
  else
    utils.log_error("vim.loop.cwd() failed")
    return nil
  end
end

function session.initialize_cache()
  -- TODO: implement the rest of the features before sessions. This isn't really
  -- necessary yet. Also learn how to use plenary functions
end

return session
