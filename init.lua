-- 基础配置
vim.o.number = true                -- 显示行号
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
vim.g.mapleader = ' '
vim.o.mouse=''


-- 自动保存配置
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local autosave_group = augroup("AutoSave", { clear = true })

-- 在插入模式离开时自动保存
autocmd("InsertLeave", {
  group = autosave_group,
  pattern = "*",
  command = "silent! write"
})

-- 在失去焦点时自动保存
autocmd("FocusLost", {
  group = autosave_group,
  pattern = "*",
  command = "silent! write"
})

-- 使用 packer.nvim 来管理插件
require('packer').startup(function()
  use 'wbthomason/packer.nvim'  -- Packer 可以管理自己

  -- 主题
  use 'gruvbox-community/gruvbox'
  use 'folke/tokyonight.nvim'
  use 'EdenEast/nightfox.nvim'

  -- 文件资源管理器
  use 'kyazdani42/nvim-tree.lua'

  -- airline
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'

  -- LSP 插件
  use 'neovim/nvim-lspconfig'   -- LSP 配置
  use 'williamboman/mason.nvim' -- LSP 安装管理器
  use 'williamboman/mason-lspconfig.nvim' -- 将 mason 和 lspconfig 连接起来

  -- 自动补全插件
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer' -- Buffer completions
  use 'hrsh7th/cmp-path' -- Path completions
  use 'hrsh7th/cmp-cmdline' -- Cmdline completions

  -- 美化补全项目的插件
  use 'onsails/lspkind-nvim' -- Pictograms for completion items
  -- 代码片段引擎
  use 'L3MON4D3/LuaSnip'
  -- 高亮
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  -- 括号匹配
  use "windwp/nvim-autopairs"
end)

-- 配置主题
vim.cmd [[colorscheme nightfox]]

-- 配置 nvim-tree
require'nvim-tree'.setup {}
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- 配置airline
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tabline#formatter'] = 'default'

-- 设置快捷键以切换标签页
vim.api.nvim_set_keymap('n', '<leader>1', ':tabnext 1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>2', ':tabnext 2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>3', ':tabnext 3<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>4', ':tabnext 4<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>5', ':tabnext 5<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>6', ':tabnext 6<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>7', ':tabnext 7<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>8', ':tabnext 8<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>9', ':tabnext 9<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tc', ':tabclose<CR>', { noremap = true, silent = true })


-- 启用电源线符号（如果支持）
vim.g.airline_powerline_fonts = 1

-- 显示文件编码
vim.g['airline#extensions#default#section_truncate_width'] = {
    b = 80,
    x = 80,
    y = 80,
    z = 80,
}

-- nvim-cmp setup
local cmp = require'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif require('luasnip').expand_or_jumpable() then
                require('luasnip').expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif require('luasnip').jumpable(-1) then
                require('luasnip').jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- 配置括号匹配
require("nvim-autopairs").setup({
    check_ts = true
})

-- 配置代码高亮
require'nvim-treesitter.configs'.setup {
  -- :TSInstallInfo 命令查看支持的语言
  ensure_installed = {"go", "c", "vim", "lua", "yaml", "python"},
  -- 启用代码高亮功能
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  -- 启用基于Treesitter的代码缩进(=) . NOTE: This is an experimental feature.
  indent = {
    enable = true
  },
  fold = {
    enable = true,  -- 启用语法折叠
  },
}


-- 配置 LSP
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "clangd", "omnisharp", "gopls" }, -- 需要的 LSP 服务器
}

local on_attach = function(client, bufnr)
  -- 使用 `:help vim.lsp.*` 获取更多信息
  local opts = { noremap=true, silent=true, buffer=bufnr }
  client.resolved_capabilities.document_diagnostics = true

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
lspconfig.gopls.setup({
    cmd = { "gopls" },
    on_attach = function(client, bufnr)
        -- 这里可以设置键绑定
        local opts = { noremap=true, silent=true }
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
        -- 更多键绑定可以在这里添加
    end,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
        },
    },
})
