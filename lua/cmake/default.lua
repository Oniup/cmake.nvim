return {
  executable = "cmake",
  reload_on_save = false,
  enable_compile_commands = false,
  opts = {}, -- NOTE: -D is automatically added to the front
  kits = {
    {
      name = "Debug",
      type = "Debug",
      generator = require("cmake.utils").os_diff("Ninja", "Make"),
      c = "gcc",
      cxx = "g++",
    },
    {
      name = "Release",
      type = "Release",
      generator = require("cmake.utils").os_diff("Ninja", "Make"),
      build_directory = "", -- if this is empty, then will add the name to the build_directory_prefix
      c = "gcc",
      cxx = "g++",
    },
  },
  build_directory_prefix = "cmake-build-",
  vimspector = {
    enabled = false,
    configuration = {
      adapter = "CodeLLDB",
      file_types = {
        "c", "cpp", "cc", "h", "hpp",
      },
      configuration = {
        request = "launch",
        program = "${workspaceRoot}/cmake-build-",
        MiMode = "gdb",
        setupCommands = {
          description = "Enable pretty-printing for gdb",
          text = "-enable-pretty-printin",
          ignoreFailures = true,
        },
      },
    },
  },
}
