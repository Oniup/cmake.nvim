local utils = require("cmake.utils")

local cmake = {}

function cmake.setup(opts)
  local default = require("cmake.default")
  utils.table_fill_missing(opts, default)
  cmake.__opts = opts

  print(vim.inspect(cmake.__opts))
end

return cmake
