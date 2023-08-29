# cmake.nvim

cmake.nvim is a simple plugin that handles cmake and building your C/C++
projects a little easier, while easily setting cmake and debug options

#### Installation and Setup

using [Vim Plug](https://github.com/junegunn/vim-plug)

```vim
Plug "Oniup/cmake.nvim"
```

Using [Packer](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "Oniup/cmake.nvim",
   config = function()
     -- ...
   end,
}
```

using [Lazy](https://github.com/folke/lazy.nvim)

```lua
return {
  "Oniup/cmake.nvim",
  opts = {
    -- ...
  },
}

-- OR

{
  "Oniup/cmake.nvim",
  opts = {
    -- ...
  },
},
```

## Commands

The current version of the plugin supports the following:

#### Basic

*   ```:CMake``` Generates CMake files
*   ```:CMakeBuild``` Builds the current CMake project
*   ```:CMakeReset``` Deletes and recreates the build directory by using
    ```:CMakeBuild``` *(in development)* 
*   ```:CMakeClean``` Deletes the build directory folder *(in development)*

#### Execute

*   ```:CMakeRun``` Builds and runs the current binary
*   ```:CMakeDebug``` Builds and runs the current binary in debug mode through
    [Vimspector](https://github.com/puremourning/vimspector) *(in development)*

## Customization

Using the default configuration as an example

```lua
require("cmake").setup({
  executable = "cmake",
  reload_on_save = false,
  enable_compile_commands = false,
  kits = {
    -- Example kit:
    -- {
    --   name = "Debug",
    --   type = "Debug",
    --   generator = require("cmake.utils").os_diff("Ninja", "Make"),
    --   build_directory = "", -- if this is empty, then will add the name to the build_directory_prefix
    --   c = "gcc",
    --   cxx = "g++",
    --   opts = {},
    -- },
  },
  build_directory_prefix = "cmake-build-",

  -- Example Vimspector configuration (it should be the same as the .json):
  vimspector = {
    -- enabled = false,
    -- configuration = {
    --   adapter = "CodeLLDB",
    --   file_types = {
    --     "c", "cpp", "cc", "h", "hpp",
    --   },
    --   configuration = {
    --     request = "launch",
    --     program = "${workspaceRoot}/cmake-build-",
    --     MiMode = "gdb",
    --     setupCommands = {
    --       description = "Enable pretty-printing for gdb",
    --       text = "-enable-pretty-printin",
    --       ignoreFailures = true,
    --     },
    --   },
    -- },
  },
})
```

#### NOTE

> This is my first plugin, so its most likely not the best option. Better
> options are [cmake4vim](https://github.com/ilyachur/cmake4vim),
> [cmake-tools.nvim](https://github.com/Civitasv/cmake-tools.nvim). However,
> using these plugins on Windows, I found to be annoying, therefore I developed
> this plugin

## License

cmake.nvim  Copyright (C) 2023  Ewan Robson
This program comes with ABSOLUTELY NO WARRANTY
This is free software, and you are welcome to redistribute it
under certain conditions

See full [LICENSE](./LICENSE)
