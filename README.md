# olddirs.nvim

olddirs.nvim is like [:oldfiles](https://neovim.io/doc/user/starting.html#%3Aoldfiles), but for
directories. It provides implementations of [:cd](https://neovim.io/doc/user/editing.html#%3Acd),
[:lcd](https://neovim.io/doc/user/editing.html#%3Alcd), and
[:tcd](https://neovim.io/doc/user/editing.html#%3Atcd) which store the directories in an olddirs
file which can be retrieved later either as a list of strings or through a
[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) picker.

## Documentation

Documentation can be found in [doc/olddirs.txt](doc/olddirs.txt) or by running `:help olddirs.nvim`.

## Getting started

### Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use('marcuscaisey/olddirs.nvim')
```

Using [vim-plug](https://github.com/junegunn/vim-plug)

```viml
Plug 'marcuscaisey/olddirs.nvim'
```

Using [dein](https://github.com/Shougo/dein.vim)

```viml
call dein#add('marcuscaisey/olddirs.nvim')
```

## Usage

A Lua API is provided which can be accessed by importing the `olddirs` module:

```lua
local olddirs = require('olddirs')
```

### Changing directories

Replace usage of the builtin Vimscript commands with the provided Lua functions.

| Original      | Replacement           |
| ------------- | --------------------- |
| `:cd {path}`  | `olddirs.cd({path})`  |
| `:lcd {path}` | `olddirs.lcd({path})` |
| `:tcd {path}` | `olddirs.tcd({path})` |

### Accessing old directories

#### olddirs.get

`olddirs.get()` returns the directories from the olddirs file in most recently used order.

#### Telescope

> :information_source: The olddirs Telescope extension must be loaded before you can use the picker,
> see the [Telescope configuration](#telescope-1) section.

The old directories can also be accessed using the Telescope picker
`telescope.extensions.olddirs.picker({opts})` which works just like the [builtin oldfiles
picker](https://github.com/nvim-telescope/telescope.nvim#vim-pickers). `opts` will be passed to the
Telescope picker.

Example mapping:

```lua
vim.keymap.set('n', '<leader>od', telescope.extensions.olddirs.picker)
```

## Configuration

### olddirs.nvim

> :information_source: The below example configuration is the default, so if you are happy with this
> then there's no need to call `olddirs.setup`.

```lua
olddirs.setup({
  file = vim.fn.stdpath('data') .. '/olddirs',
  limit = 100,
})
```

| Key     | Type     | Description                               |
| ------- | -------- | ----------------------------------------- |
| `file`  | `string` | The file to store the old directories in. |
| `limit` | `number` | The max number old directories to store.  |

### Telescope

To use the olddirs picker, you must load the Telescope extension:

```lua
telescope.load_extension('olddirs')
```

To configure the picker:

> :information_source: The below example configuration is the default, so if you are happy with this
> then there's no need to provide it to `telescope.setup`.

```lua
telescope.setup({
  extensions = {
    olddirs = {
      path_callback = olddirs.lcd,
      ...
    },
  },
})
```

| Key             | Type           | Description                                                    |
| --------------- | -------------- | -------------------------------------------------------------- |
| `path_callback` | `func({path})` | The function which will be called with the selected directory. |

You can also provide any generic picker config in this section. For example:

```lua
telescope.setup({
  extensions = {
    olddirs = {
      path_callback = olddirs.cd,
      layout_config = {
        width = 0.6,
        height = 0.9,
      },
      previewer = false,
      path_display = function(_, path)
        return path:gsub('^' .. os.getenv('HOME'), '~')
      end,
    },
  },
})
```
