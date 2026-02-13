-- enable experimental Lua module loader
vim.loader.enable()

local constants = require "custom.constants"
local nvim_utils = require "custom.utils.nvim"

-- PERF: disable nvim syntax, which causes severe lag
-- however you can still enable it per buffer with a
-- FileType autocmd that calls `:set syntax=<filetype>`
vim.cmd.syntax "manual"

require "custom.options"
require "custom.globals"

-- lazy load ./plugins/*
require "custom.lazy"

-- lazy load ./autocmds.lua, ./keymaps.lua, ./macros.lua, ./commands.lua
if constants.has_file_arg then
  require "custom.autocmds"
end
nvim_utils.autocmd("User", {
  group = nvim_utils.augroup "load_core",
  pattern = "VeryLazy",
  callback = function()
    if not constants.has_file_arg then
      require "custom.autocmds"
    end
    require "custom.keymaps"
    require "custom.commands"
  end,
})

vim.cmd.colorscheme "poimandres"
