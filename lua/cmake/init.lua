local utils = require("cmake.utils")
local job = require("cmake.job")

local cmake = {}
cmake.get_generator_commands = {
  make = function(build_folder)
    -- TODO: ...
  end,
  ninja = function(build_folder)
    local command = { "ninja", "-C", build_folder }
    if cmake.__selected_build_target ~= nil then
      table.insert(command, cmake.__selected_build_target)
    end
    return command
  end,
  msbuild = function(build_folder)
    -- TODO: ...
  end,
}

function cmake.setup(opts)
  local default = require("cmake.default")
  utils.table_fill_missing(opts, default)
  cmake.__opts = opts
end

function cmake.get_selected_kit()
  if cmake.__selected_kit == nil then
    cmake.__selected_kit = cmake.__opts.kits[1]
  end
  return cmake.__selected_kit
end

function cmake.get_build_folder(kit)
  if kit.build_directory == nil then
    local suffix = kit.name
    if suffix == nil then
      suffix = kit.type
      if suffix == nil then
        utils.log_error("It is required to give the type of the kit")
        return nil
      end
    end
    return cmake.__opts.build_directory_prefix .. suffix
  end
  return kit.name
end

function cmake.build_targets()
  local build_folder = cmake.get_build_folder(cmake.get_selected_kit())
  if build_folder == nil then
    utils.log_error("No build folder defined")
    return nil
  end
  local command = {
    cmake.__opts.executable, "--build", build_folder, "--target", "help" }
  job.run_in_split(command)
end

function cmake.select_build_target(target)
  cmake.__selected_build_target = target
end

function cmake.select_kit(target, check_type)
  if type(target) == "number" then
    if target <= #cmake.__opts.kits then
      cmake.__selected_kit = cmake.__opts.kits[target]
      return true
    end
    utils.log_error("Kit index (" .. target .. ") is greater than the total kits ("
      .. #cmake.__opts.kits .. ")")
  elseif type(target) == "string" then
    if check_type == nil then
      check_type = false
    end
    for i = 1, #cmake.__opts.kits do
      if check_type then
        if cmake.__opts.kits[i].type == target then
          cmake.__selected_kit = cmake.__opts.kits[i]
          return true
        end
      else
        if cmake.__opts.kits[i].name == target then
          cmake.__selected_kit = cmake.__opts.kits[i]
          return true
        end
      end
    end
    utils.log_error("No kits found named " .. target)
  else
    utils.log_error("Invalid type for selecting kit, target can either be a " ..
      "number (index) or a string (name)")
  end
  return false
end

function cmake.select_target(index, results)
  -- TODO: ...
end

function cmake.get_generate_command()
  local kit = cmake.get_selected_kit()
  if kit == nil then return nil end
  local build_directory = cmake.get_build_folder(kit)
  if build_directory == nil then return nil end

  local command = {
    cmake.__opts.executable, "-S", ".", "-B", build_directory,
  };

  if kit.generator ~= nil then
    table.insert(command, "-G" .. kit.generator)
  end

  if kit.type == nil then
    utils.log_error("It is required to give the type of the kit")
    return nil
  end
  table.insert(command, "-DCMAKE_BUILD_TYPE=" .. kit.type)

  if kit.c ~= nil then
    table.insert(command, "-DCMAKE_C_COMPILER=" .. kit.c)
  end
  if kit.cxx ~= nil then
    table.insert(command, "-DCMAKE_CXX_COMPILER=" .. kit.cxx)
  end

  if kit.opts ~= nil then
    if type(kit.opts) == "table" then
      for i = 1, #kit.opts do
        table.insert(command "-D" .. kit.opts[i])
      end
    else
      utils.log_error("incorrect type for kit's opts, requires a table of " ..
        "cmake commands as a stirng")
      return nil
    end
  end

  if cmake.__opts.enable_compile_commands then
    table.insert(command, "-DCMAKE_EXPORT_COMPILE_COMMANDS=1")
  end

  return command
end

function cmake.get_build_command()
  local kit = cmake.get_selected_kit()
  local build_folder = cmake.get_build_folder(kit)
  if build_folder == nil then
    return nil
  end

  local command;
  if kit.generator ~= nil then
    command = cmake.get_generator_commands[string.lower(kit.generator)](build_folder)
  else
    if vim.fn.has("win32") then
      command = cmake.get_generator_commands.ninja(build_folder)
    else
      command = cmake.get_generator_commands.make(build_folder)
    end
  end

  return command
end

function cmake.generate()
  local command = cmake.get_generate_command()
  if command ~= nil then
    job.run_in_split(command)
  end
end

function cmake.build()
  local command = cmake.get_build_command()
  if command ~= nil then
    job.run_in_split(command)
  end
end

function cmake.run()
  if cmake.__selected_build_target ~= nil then
    local executable = cmake.__selected_build_target
    if vim.fn.has("win32") then
      executable = executable .. ".exe"
    end

    local build_folder = cmake.get_build_folder(cmake.get_selected_kit())
    if build_folder ~= nil then
      local command
      if vim.fn.has("win32") then
        command = { ".\\" .. build_folder .. "\\" .. executable }
      else
        command = { "./" .. build_folder .. "/" .. executable }
      end
      job.run_in_split(command)
    else
      utils.log_error("No build folder")
    end
  else
    utils.log_error("Need to select build target")
  end
end

return cmake
