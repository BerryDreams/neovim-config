-- 基础配置
vim.o.number = true                -- 显示行号
vim.o.relativenumber = true        -- 相对行号
vim.o.expandtab = true             -- 使用空格替代 Tab
vim.o.shiftwidth = 4               -- 缩进的宽度
vim.o.tabstop = 4                  -- Tab 字符的宽度
vim.o.smartindent = true           -- 智能缩进
vim.o.wrap = false                 -- 不自动换行
vim.o.swapfile = false             -- 禁用 swap 文件
vim.o.backup = false               -- 禁用备份文件
vim.o.undodir = os.getenv("HOME") .. "/.config/nvim/undo"  -- 设置撤销文件的目录
vim.o.undofile = true              -- 启用撤销文件
vim.o.hlsearch = false             -- 禁用高亮搜索
vim.o.incsearch = true             -- 启用增量搜索
vim.o.termguicolors = true         -- 启用终端真彩色


-- 使用 packer.nvim 来管理插件
require('packer').startup(function()
  use 'wbthomason/packer.nvim'  -- Packer 可以管理自己

  -- 主题
  use 'gruvbox-community/gruvbox'
  use 'folke/tokyonight.nvim'

  -- 文件资源管理器
  use 'kyazdani42/nvim-tree.lua'

  -- LSP 插件
  use 'neovim/nvim-lspconfig'   -- LSP 配置
  use 'williamboman/mason.nvim' -- LSP 安装管理器
  use 'williamboman/mason-lspconfig.nvim' -- 将 mason 和 lspconfig 连接起来
end)


-- 配置主题
vim.cmd [[colorscheme tokyonight]]


-- 配置 nvim-tree
require'nvim-tree'.setup {}
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- 配置 LSP
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "clangd", "omnisharp" }, -- 需要的 LSP 服务器
}

-- 快捷键配置
local on_attach = function(client, bufnr)
  -- 使用 `:help vim.lsp.*` 获取更多信息
  local opts = { noremap=true, silent=true, buffer=bufnr }

  -- 定义快捷键
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
end


local lspconfig = require'lspconfig' -- 开始配置每个服务器
lspconfig.clangd.setup{
    on_attach = on_attach
}
lspconfig.omnisharp.setup{
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  on_attach = on_attach
}



