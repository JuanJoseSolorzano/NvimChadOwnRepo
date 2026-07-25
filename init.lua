vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Own settings
-- Enable folding based on indentation
vim.o.foldmethod = 'indent'
vim.o.foldlevel = 99  -- Start unfolded
vim.o.foldenable = true  -- Enable folding
-- Map 'zc' to fold a block of code
vim.api.nvim_set_keymap('n', 'zc', 'za', { noremap = true, silent = true })
-- Map 'zo' to unfold a block of code
vim.api.nvim_set_keymap('n', 'zo', 'zo', { noremap = true, silent = true })
-- Map 'zR' to unfold all
vim.api.nvim_set_keymap('n', 'zR', 'zR', { noremap = true, silent = true })
-- Map 'zM' to fold all
vim.api.nvim_set_keymap('n', 'zM', 'zM', { noremap = true, silent = true })
-- wrap lines
vim.opt.wrap = false
vim.opt.linebreak = false
vim.opt.breakindent = false
-- Custom ident
vim.opt.tabstop = 4        -- Number of spaces for a tab
vim.opt.shiftwidth = 4     -- Number of spaces for each step of auto-indentation
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.smartindent = true  -- Enable smart indentation
vim.opt.autoindent = true   -- Enable automatic indentation
