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
require("cmake").setup({
  -- TODO: ...
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
