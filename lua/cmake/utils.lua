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

local function table_fill_missing(dest, default, key)
  if dest[key] == nil then
    dest[key] = default[key]
  else
    if type(dest[key]) ~= type(default[key]) then
      utils.log_error("Incorrect type, make sure that all options are"
        .. " of the correct type by using :help cmake.nvim")
    elseif type(dest[key]) == "table" then
      for k, _ in pairs(default[key]) do
        table_fill_missing(dest[key], default[key], k)
      end
    end
  end
end

function utils.table_fill_missing(dest, default)
  if dest == nil then
    dest = default
  else
    for k, _ in pairs(default) do
      table_fill_missing(dest, default, k)
    end
  end
end

function utils.table_length(opts)
  local n = 0
  for _ in pairs(opts) do
    n = n + 1
  end
  return n
end

function utils.list_to_string(list)
  local str = ""
  for i = 1, #list do
    str = str .. " " .. list[i]
  end
  return str
end

return utils
