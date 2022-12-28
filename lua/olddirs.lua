---@brief [[
---*olddirs.nvim*
---olddirs.nvim is like |:oldfiles|, but for directories.
---@brief ]]

---@toc olddirs-contents

---@mod olddirs-intro INTRODUCTION
---@brief [[
---olddirs.nvim provides |autocommand|s which store the current directory in an
---olddirs file when Neovim starts or the directory is changed with |:cd|,
---|:lcd|, or |:tcd|. The old directories can be retrieved as a list of strings
---or through a |telescope.nvim| picker.
---@brief ]]

---@mod olddirs OLDDIRS
---@brief [[
---The olddirs.nvim Lua API can be accessed by importing the `oldirs` module with
--->lua
---  local olddirs = require('olddirs')
---<
---@brief ]]

local config = require('olddirs._config')

local olddirs = {}

---Configure olddirs.nvim. This is only required if you want to change the
---defaults.
---@param opts table options
---  * {file} (string): file to store the olddirs in
---    Default: stdpath('data') .. '/olddirs'
---  * {limit} (number): max number of dirs to store in the olddirs file
---    Default: 100
olddirs.setup = function(opts)
  config.update(opts)
end

---Returns the directories from the olddirs file if it exists, otherwise an
---empty table.
---@return string[] directories directories in most recently used order
olddirs.get = function()
  local f = io.open(config.get().file, 'r')
  if not f then
    return {}
  end
  local dirs = {}
  for line in f:lines() do
    table.insert(dirs, line)
  end
  f:close()
  return dirs
end

---@mod olddirs-telescope TELESCOPE
---@brief [[
---Old directories can also be accessed through the |telescope.nvim| picker. To
---do so, you must first load the extension:
--->lua
---  telescope.load_extension('olddirs')
---<
---
---To open the picker, call `telescope.extensions.olddirs.picker({opts})`. `opts`
---can include generic Telescope picker options.
---
---Example mapping:
--->lua
---  vim.keymap.set('n', '<leader>od', telescope.extensions.olddirs.picker)
---<
---
---To configure the picker, include the configuration in a call to
---`telescope.setup({opts})`:
--->lua
---  telescope.setup({
---    extensions = {
---      olddirs = {
---        path_callback = vim.cmd.lcd,
---        ...
---      },
---    },
---  })
---<
---`path_callback({path})` is the function which will be called with the selected
---directory.
---
---This above configuration is the default, so if you're happy with it then
---there's no need to include it in a call to `telescope.setup({opts})`.
---
---
---You can also provide any generic picker config in this section. For example:
--->lua
---  telescope.setup({
---    extensions = {
---      olddirs = {
---        path_callback = vim.cmd.cd,
---        layout_config = {
---          width = 0.6,
---          height = 0.9,
---        },
---        previewer = false,
---        path_display = function(_, path)
---          return path:gsub('^' .. os.getenv('HOME'), '~')
---        end,
---      },
---    },
---  })
---<
---@brief ]]

return olddirs
