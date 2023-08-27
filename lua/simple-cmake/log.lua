local M = {}

M.log = function(message, level)
  vim.notify(message, level, { title = "SimpleCMake"})
end

M.info = function(message)
  M.log(message, vim.log.levels.INFO)
end

M.warning = function(message)
  M.log(message, vim.log.levels.WARN)
end

M.error = function(message)
  M.log(message, vim.log.levels.ERROR)
end

return M
