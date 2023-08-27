# simple-cmake.nvim

simple-cmake.nvim is a simple plugin that handles cmake and building your C/C++
projects a little easier, while easily setting cmake and debug options

#### Installation and Setup

using [Vim Plug](https://github.com/junegunn/vim-plug)

```vim
Plug "Oniup/simple-cmake.nvim"
```

Using [Packer](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "Oniup/simple-cmake.nvim",
   config = function()
     -- ...
   end,
}
```

using [Lazy](https://github.com/folke/lazy.nvim)

```lua
return {
  "Oniup/simple-cmake.nvim",
  opts = {
    -- ...
  },
}

-- OR

{
  "Oniup/simple-cmake.nvim",
  opts = {
    -- ...
  },
},
```

## Commands

The current version of the plugin supports the following:

#### Basic

*   ```:CMakeGenerate``` Generates CMake files
*   ```:CMakeBuild``` Builds the current CMake project
*   ```:CMakeReset``` Deletes and recreates the build directory by using
    ```:CMakeBuild```
*   ```:CMakeClean``` Deletes the build directory folder

#### Execute

*   ```:CMakeRun``` Builds and runs the current binary
*   ```:CMakeDebug``` Builds and runs the current binary in debug mode through
    [Vimspector](https://github.com/puremourning/vimspector)
*   ```:CMake```

## Customization

Using the default configuration as an example

```lua
require("simple-cmake").setup({
  -- Common
  executable = "cmake",
  reload_after_save = false,
  enable_compile_commands = false,
  vimspector_support = false,
  extra_opts = {}, -- -D prefix options

  -- Build path
  build_directory_prefix = "cmake-build-",
  build_type = "Debug" | "Release", -- default build type
  generator = "Ninja" | "Make",
  kits_path = nil, -- NOTE: CMake kits are not supported yet

  -- Debugging through Vimspector
  -- NOTE: the default value for vimspector_default_opts is nil
  -- This is just example opts that uses clangd
  -- See adapters from https://github.com/puremourning/vimspector#c-c-rust-etc
  vimspector_default_opts = {
    adapter = "clangd",
    configuration = {
      request = "Launch",
      program = nil, -- keep nil if you want plugin to handle directory
      cwd = "${workspaceRoot}",
      stopAtEntry = false,
      MiMode = "gdb",
      setupCommands = {
        {
          description = "Enable pretty-printing for gdb",
          text = "-enable-pretty-printing",
          ignoreFailures = false
        },
      },
    },
  },
})
```

#### NOTE

> This is my first plugin, so its most likely not the best option. Better
> options are [cmake4vim](https://github.com/ilyachur/cmake4vim),
> [cmake-tools.vim](https://github.com/Civitasv/cmake-tools.nvim). However,
> using these plugins on Windows, I found to be annoying, therefore I developed
> this plugin
