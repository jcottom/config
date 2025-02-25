-- tab/indent
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.smartindent = true

-- line numbers
vim.opt.number = true

-- wrap lines at word boundary
vim.opt.linebreak = true

-- persistent undo
vim.opt.undofile = true

-- don't mess with eol
vim.opt.fixeol = false

-- completion
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.wildcharm = vim.opt.wildchar:get()

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------

-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>h", ":nohlsearch<cr>")
vim.keymap.set("n", "<leader><space>", "<c-^>")

vim.keymap.set("n", "gA", "ga")
vim.keymap.set("n", "ga", "<Plug>(UnicodeGA)")

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------

-- bootstrap Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- list packages
require("lazy").setup({
  "airblade/vim-rooter",
  "airblade/vim-gitgutter",
  "nvim-lualine/lualine.nvim",
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {"nvim-lua/plenary.nvim"},
    keys = {
      {"<leader><tab>", "<cmd>Telescope buffers<cr>"},
      {"<leader>t", "<cmd>Telescope<cr>"},
      {"<C-p>", "<cmd>Telescope find_files<cr>"}
    }
  },
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },

  "ellisonleao/gruvbox.nvim",
  "nvim-tree/nvim-web-devicons",
  "chrisbra/unicode.vim",

  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  "tpope/vim-unimpaired",
  "tpope/vim-fugitive"
})


--require("core.keymaps")
--require("core.plugins")

-- get vim-rooter to switch to ~/.config/dir
vim.cmd("let g:rooter_patterns += [\">.config\"]")

vim.opt.termguicolors = true
vim.cmd [[ colorscheme gruvbox ]]

--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------
lspconfig = require("lspconfig")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format { async = true } end, bufopts)
end

lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  cmd = {"rustup", "run", "stable", "rust-analyzer"}
}

lspconfig.hls.setup {
  on_attach = on_attach,
}

lspconfig.texlab.setup {
  on_attach = on_attach,
}

--------------------------------------------------------------------------------
-- Lualine
--------------------------------------------------------------------------------
require("lualine").setup {
	options = {
		icons_enabled = true,
    theme = "gruvbox",
	},
	sections = {
		lualine_a = {
			{
				"filename",
				path = 1,
			}
		}
	}
}
