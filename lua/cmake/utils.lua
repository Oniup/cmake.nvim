local utils = {}

utils.log = function(msg, level)
  vim.notify(msg, level, { list = "Cutilsake:" })
end

function utils.log_info(msg)
  utils.log(msg, vim.log.levels.INFO)
end

function utils.log_warning(msg)
  utils.log(msg, vim.log.levels.WARN)
end

function utils.log_error(msg)
  utils.log(msg, vim.log.levels.ERROR)
end

function utils.os_diff(win32_result, unix_result)
  if vim.fn.has("win32") then
    return win32_result
  else
    return unix_result
  end
end

function utils.table_length(opts)
  local n = 0
  for _ in pairs(opts) do
    n = n + 1
  end
  return n
end

--- @param list table
--- @return string
function utils.list_to_string(list)
  if #list > 1 then
    local str = list[1]
    for i = 2, #list do
      str = str .. " " .. list[i]
    end
    return str
  end
  return ""
end

return utils
