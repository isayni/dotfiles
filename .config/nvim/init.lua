-- ~/.config/nvim/init.lua

-- -----------------------------------------------------------------------------
-- # LAZY.NVIM BOOTSTRAP
-- -----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- -----------------------------------------------------------------------------
-- # GENERAL OPTIONS
-- -----------------------------------------------------------------------------
vim.g.mapleader = ","

-- Core editor behavior
vim.opt.encoding = "utf-8"
vim.opt.winborder = "rounded"   -- Use rounded borders for floating windows
vim.opt.mouse = "a"             -- Enable mouse support in all modes
vim.opt.swapfile = false        -- Disable swap files (reduces clutter)
vim.opt.backup = false          -- Disable backup files
vim.opt.writebackup = false     -- Disable write backup files
vim.opt.undofile = true         -- Enable persistent undo (survives restarts)
vim.opt.updatetime = 300        -- Faster update time for plugins (CursorHold, etc.)
vim.opt.hidden = false          -- Do not allow unsaved buffers to be hidden
vim.opt.termguicolors = true    -- Enable 24-bit RGB color support in the terminal

-- Indentation settings
vim.opt.autoindent = true       -- Copy indent from the current line when starting a new line
vim.opt.smartindent = true      -- Automatically insert extra indent in certain cases (e.g., after '{')
vim.opt.expandtab = true        -- Use spaces instead of tab characters
vim.opt.tabstop = 4             -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = 4         -- Number of spaces inserted/removed when pressing <Tab>/<BS>
vim.opt.shiftwidth = 4          -- Number of spaces used for each level of auto-indentation

-- Display and layout
vim.opt.wrap = true             -- Wrap long lines visually (does not insert line breaks)
vim.opt.linebreak = true        -- Break wrapped lines at word boundaries, not mid-word
vim.opt.scrolloff = 5           -- Always keep at least 5 lines visible above/below the cursor
vim.opt.cursorline = true       -- Highlight the line the cursor is currently on
vim.opt.number = true           -- Show absolute line numbers
vim.opt.relativenumber = true   -- Show relative line numbers (useful for motions like 5j)
vim.opt.splitright = true       -- Open new vertical splits to the right of the current window
vim.opt.splitbelow = true       -- Open new horizontal splits below the current window
vim.opt.signcolumn = "yes"      -- Always show the sign column (prevents layout shifting)
vim.opt.laststatus = 0          -- Hide the default statusline (managed by lualine)
vim.opt.cmdheight = 0           -- Hide the command line when not in use (merged with statusline)

-- Search settings
vim.opt.hlsearch = true         -- Highlight all matches of the current search pattern
vim.opt.incsearch = true        -- Show search matches incrementally as you type
vim.opt.ignorecase = true       -- Case-insensitive search by default
vim.opt.smartcase = true        -- Override ignorecase if search pattern contains uppercase letters

-- Folding
vim.opt.foldmethod = "indent"   -- Fold code based on indentation level
vim.opt.foldlevel = 99          -- Open all folds by default when a file is opened

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '󰌵',
        },
    },
    float = {
        border = "rounded",
    },
})

-- Autodetect Ansible based on directory structure
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.yml", "*.yaml" },
  callback = function(args)
    local path = vim.api.nvim_buf_get_name(args.buf)
    -- Check if the path contains 'roles/' or 'playbooks/'
    if path:match("/roles/") or path:match("/playbooks/") then
      vim.bo[args.buf].filetype = "yaml.ansible"
    end
  end,
})

-- -----------------------------------------------------------------------------
-- # KEYMAPS
-- -----------------------------------------------------------------------------
local keymap_opts = { noremap = true, silent = true }

-- Clear search highlight
vim.keymap.set("n", "<leader>l", ":nohl<CR>", keymap_opts)

-- Line wrapping and navigation
vim.keymap.set("n", "j", "gj", keymap_opts)
vim.keymap.set("n", "k", "gk", keymap_opts)
vim.keymap.set("n", "Y", "y$", keymap_opts) -- Yank to end of line

-- Move lines up/down in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", keymap_opts)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", keymap_opts)

-- Indent in visual mode
vim.keymap.set("v", ">", ">gv", keymap_opts)
vim.keymap.set("v", "<", "<gv", keymap_opts)

-- Global replace
vim.keymap.set("n", "S", ":%s///g<Left><Left>", keymap_opts)

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", keymap_opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", keymap_opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", keymap_opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", keymap_opts)
vim.keymap.set("i", "<C-h>", "<C-w>h", keymap_opts)
vim.keymap.set("i", "<C-j>", "<C-w>j", keymap_opts)
vim.keymap.set("i", "<C-k>", "<C-w>k", keymap_opts)
vim.keymap.set("i", "<C-l>", "<C-w>l", keymap_opts)

-- Window resizing
vim.keymap.set("n", "<leader>=", ":vertical resize +10<CR>", keymap_opts)
vim.keymap.set("n", "<leader>-", ":vertical resize -10<CR>", keymap_opts)

-- Tab navigation
vim.keymap.set("n", "<Leader><Tab>", ":tabnext<CR>", keymap_opts)
vim.keymap.set("n", "<Leader><S-Tab>", ":tabprevious<CR>", keymap_opts)
vim.keymap.set("n", "<C-n>", ":tabnew<CR>", keymap_opts)

-- Folding
vim.keymap.set("n", "`", "za", keymap_opts)

-- LSP
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")

-- -----------------------------------------------------------------------------
-- # AUTOCMD (Automations)
-- -----------------------------------------------------------------------------
-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- WSL Yank support
if vim.fn.executable("/mnt/c/Windows/System32/clip.exe") then
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = vim.api.nvim_create_augroup("WSLYank", { clear = true }),
        pattern = "*",
        callback = function()
            -- Only copy to clipboard for explicit yank operations (y/Y), not d/c/s etc.
            if vim.v.event.operator == "y" then
                vim.fn.system("/mnt/c/Windows/System32/clip.exe", vim.fn.getreg('"'))
            end
        end,
    })
end

-- Auto rooter
local root_names = { '.git' } -- file names indicating root directory
local root_cache = {}
local set_root = function()
    local path = vim.api.nvim_buf_get_name(0) -- Get directory path to start search from
    if path == '' then return end
    path = vim.fs.dirname(path)
    local root = root_cache[path]
    if root == nil then -- Try cache and resort to searching upward for root directory
        local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
        if root_file == nil then return end
        root = vim.fs.dirname(root_file)
        root_cache[path] = root
    end
    vim.fn.chdir(root) -- Set current directory
end
local root_augroup = vim.api.nvim_create_augroup('MyAutoRoot', {})
vim.api.nvim_create_autocmd('BufEnter', { group = root_augroup, callback = set_root })

-- -----------------------------------------------------------------------------
-- # PLUGINS
-- -----------------------------------------------------------------------------
require("lazy").setup({
    ui = {
        border = "rounded",
    },
    spec = {
        -- Colorschemes
        {
            "ellisonleao/gruvbox.nvim",
            priority = 1000,
            config = function()
                require("gruvbox").setup({
                    italic = {
                        strings = false,
                        emphasis = false,
                        comments = false,
                        operators = false,
                        folds = false,
                    },
                    transparent_mode = true,
                    overrides = {
                        StatusLine = { bg = "none" },
                        StatusLineNC = { bg = "none" },
                        WinBar = { bg = "none" },
                        WinBarNC = { bg = "none" },
                    }
                })
                vim.cmd.colorscheme("gruvbox")
            end,
        },
        {
            "tiagovla/tokyodark.nvim",
            config = function()
                require("tokyodark").setup({
                    styles = {
                        comments    = { italic = false },
                        keywords    = { italic = false },
                        identifiers = { italic = false },
                        functions   = { italic = false },
                        variables   = { italic = false },
                    },
                    transparent_background = true,
                    custom_highlights = {
                        StatusLine = { bg = "none" },
                        StatusLineNC = { bg = "none" },
                        WinBar = { bg = "none" },
                        WinBarNC = { bg = "none" },
                    }
                })
            end,
        },
        { "folke/tokyonight.nvim" },

        -- Statusline
        {
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            event = "VeryLazy",
            config = function()
                local auto = require "lualine.themes.auto"
                local lualine_modes = { "insert", "normal", "visual", "command", "replace", "inactive", "terminal" }
                for _, field in ipairs(lualine_modes) do
                  if auto[field] and auto[field].c then auto[field].c.bg = "NONE" end
                end

                local branch_component = require('lualine.components.branch'):extend()
                branch_component.update_status = function(_, is_focused)
                    local branch = branch_component.super.update_status(_, is_focused)
                    if #branch > 26 then
                        branch = branch:sub(1, 26) .. "..."
                    end
                    return branch
                end

                local function winbar_filter()
                    local excluded_filetypes = {"Avante", "NvimTree"}
                    for _, ft in ipairs(excluded_filetypes) do
                        if string.find(vim.bo.filetype, ft) then
                            return false
                        end
                    end
                    return true
                end

                require("lualine").setup({
                    options = {
                        theme = auto,
                        icons_enabled = true,
                        component_separators = "|",
                        section_separators = { left = '', right = '' },
                        globalstatus = true,
                    },
                    sections = {
                        lualine_a = {
                            {
                                'mode',
                                separator = {
                                    left = '', right = ''
                                },
                            }
                        },
                        lualine_b = {
                            {
                                branch_component,
                                icon=""
                            },
                            -- branch_component,
                            function()
                                if vim.bo.readonly then
                                    return " "
                                else
                                    return ""
                                end
                            end,
                            {
                                "diff",
                                symbols = {
                                    added = " ",
                                    modified = " ",
                                    removed = " ",
                                },
                            },
                        },
                        lualine_c = {

                        },
                        lualine_x = {
                        },
                        lualine_y = {
                            {
                                "diagnostics",
                                symbols = {
                                    error = " ",
                                    warn = " ",
                                    info = " ",
                                    hint = "󰌵 ",
                                    Error_alt = "󰅚",
                                    Warning_alt = "󰀪",
                                    Information_alt = "",
                                    Hint_alt = "󰌶",
                                }
                            },
                            {
                                'encoding',
                            },
                            {
                                'filetype',
                            },
                        },
                        lualine_z = {
                            {
                                'progress',
                                padding = 0
                            },
                            {
                                'location',
                                separator = { left = '', right = '' },
                                padding = { left = 1 },
                            },
                            {
                                'searchcount',
                                maxcount = 999999,
                                separator = { left = '', right = '' },
                                padding = { left = 1 }
                            },
                        },
                    },
                    winbar = {
                        lualine_a = {
                            {
                                'filename',
                                separator = {
                                    left = '', right = ''
                                },
                                cond = winbar_filter,
                            }
                        },
                        lualine_c = { },
                    },
                    inactive_winbar = {
                        lualine_a = {
                            {
                                'filename',
                                separator = {
                                    left = '', right = ''
                                },
                                cond = winbar_filter,
                            }
                        },
                    },
                })
                if vim.env.TMUX then
                    vim.api.nvim_create_autocmd({ "FocusGained", "ColorScheme", "VimEnter" }, {
                      callback = function()
                        vim.defer_fn(function()
                          vim.opt.laststatus = 0
                        end, 100)
                      end,
                    })
                    vim.opt.laststatus = 0
                end
            end,
        },

        -- File Explorer
        {
            "nvim-tree/nvim-tree.lua",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            keys = {
                { "<leader>e", '<cmd>NvimTreeToggle<CR>',  desc = "toggle file tree", },
            },
            config = function()
                local function my_on_attach(bufnr)
                    local api = require('nvim-tree.api')

                    local function opts(desc)
                    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                    end

                    -- Default mappings
                    api.config.mappings.default_on_attach(bufnr)

                    -- Split mappings
                    vim.keymap.set("n", "<C-v>", api.node.open.vertical,   opts("Open: Vertical Split"))
                    vim.keymap.set("n", "<C-s>", api.node.open.horizontal, opts("Open: Horizontal Split"))

                    -- Custom mapping: Live Grep in Node
                    vim.keymap.set('n', '<leader>rg', function()
                        local node = api.tree.get_node_under_cursor()
                        if not node then return end

                        -- Determine the search directory
                        local cwd = vim.fn.getcwd():gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
                        local path = string.gsub(node.absolute_path, "^" .. cwd .. "/", "")

                        -- Launch Telescope live_grep in that path
                        require('telescope.builtin').live_grep({
                          search_dirs = { path },
                          prompt_title = "Live Grep in '" .. path .. "'"
                        })
                    end, opts('Telescope Live Grep'))
                end

                vim.g.loaded_netrw = 1
                vim.g.loaded_netrwPlugin = 1
                require("nvim-tree").setup({
                    on_attach = my_on_attach,
                    git = {
                        enable = true,
                        ignore = false,
                    },
                    view = {
                        width = 30,
                    },
                    renderer = {
                        group_empty = true,
                    },
                    filters = {
                        dotfiles = false,
                        custom = { '^.git$' },
                    },
                    sync_root_with_cwd = false,
                    update_focused_file = {
                        enable = true,
                    },
                })
            end,
        },

        -- LSP, linting
        {
            "mason-org/mason-lspconfig.nvim",
            opts = {},
            dependencies = {
                {
                    "mason-org/mason.nvim",
                    opts = {
                        ui = {
                            border = "rounded",
                        },
                    },
                },
                {
                    "neovim/nvim-lspconfig",
                },
                {
                    "folke/lazydev.nvim",
                    ft = "lua",
                    opts = {},
                },
            },
        },

        -- Autocomplete
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                {'hrsh7th/cmp-buffer'},
                {'hrsh7th/cmp-path'},
                {'hrsh7th/cmp-nvim-lsp'},
            },
            config = function()
                local cmp = require("cmp")
                cmp.setup({
                    snippet = {
                      expand = function(args)
                        vim.snippet.expand(args.body) -- native neovim snippets
                      end,
                    },
                    mapping = cmp.mapping.preset.insert({
                        ['<C-j>'] = cmp.mapping.select_next_item(),
                        ['<C-k>'] = cmp.mapping.select_prev_item(),
                        ['<C-Space>'] = cmp.mapping.complete(),
                        ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    }),
                    window = {
                        completion = cmp.config.window.bordered({
                            winhighlight = "Normal:Normal,FloatBorder:NormalFloat,CursorLine:Visual,Search:None"
                        }),
                        documentation = cmp.config.window.bordered({
                            winhighlight = "Normal:Normal,FloatBorder:NormalFloat,CursorLine:Visual,Search:None"
                        }),
                    },
                    sources = {
                        { name = "lazydev" },
                        { name = "nvim_lsp" },
                        { name = "path" },
                        {
                            name = "buffer",
                            option = {
                                get_bufnrs = function() -- hint from all buffers
                                    return vim.api.nvim_list_bufs()
                                end
                            }
                        }
                    },
                    experimental = {
                        ghost_text = true,
                    }
                })
            end,
        },

        -- Notifications
        {
            "j-hui/fidget.nvim",
            opts = {

            }
        },

        -- Syntax highlighting
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "html", "css", "json", "yaml", "python", "latex", "bash" },
                    sync_install = false,
                    auto_install = true,
                    highlight = { enable = true },
                    indent = { enable = true },
                    ignore_install = {},
                    modules = {},
                })
            end,
        },

        -- Undotree
        {
            "mbbill/undotree",
            keys = {
                { "<leader>u", '<cmd>UndotreeToggle<cr>',  desc = "toggle Undotree", },
            },
            defaults = {

            },
        },

        -- Fuzzy Finder
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope-ui-select.nvim",
                "debugloop/telescope-undo",
                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    build = "make"
                },
            },
            keys = {
                { "<C-f>",      '<cmd>Telescope git_files<cr>',    desc = "Git files", },
                { "<leader>rg", '<cmd>Telescope live_grep<cr>',    desc = "Ripgrep", },
                { "<leader>ff", '<cmd>Telescope find_files<cr>',   desc = "Find files", },
                { "<leader>fs", '<cmd>Telescope grep_string<cr>',  desc = "Grep string", },
                { "<leader>fu", '<cmd>Telescope undo<cr>',         desc = "Undo history", },
                { "<leader>b",  '<cmd>Telescope buffers<cr>',      desc = "Buffers", },
                { "<leader>gc", '<cmd>Telescope git_commits<cr>',  desc = "Git commits", },
                { "<leader>gb", '<cmd>Telescope git_branches<cr>', desc = "Git branches", },
            },
            config = function()
                require("telescope").setup({
                    defaults = {
                        mappings = {
                            i = {
                                ["<esc>"] = require("telescope.actions").close,
                                ["<C-k>"] = require("telescope.actions").move_selection_previous,
                                ["<C-j>"] = require("telescope.actions").move_selection_next,
                                ["<C-s>"] = require("telescope.actions").select_horizontal,
                                ["<C-v>"] = require("telescope.actions").select_vertical,
                            },
                        },
                        path_display = { truncate = 3 },
                        layout_strategy = "horizontal",
                    },
                    pickers = {
                        live_grep = {
                            file_ignore_patterns = { '.git/' },
                            additional_args = { "--hidden" },
                            path_display = { "shorten" },
                            layout_strategy = "vertical",
                            layout_config = {
                                preview_height = 0.4,
                            },
                        },
                    },
                    extensions = {
                        ["ui-select"] = {
                            require("telescope.themes").get_dropdown {},
                        },
                        undo = {
                            layout_config = {
                                horizontal = {
                                    preview_width = 0.7,
                                },
                            },
                        },
                        fzf = {},
                    },
                })
                require("telescope").load_extension("ui-select")
                require("telescope").load_extension("fzf")
            end,
        },

        -- Git integration
        { "tpope/vim-fugitive" },
        { "lewis6991/gitsigns.nvim" },
        { "sindrets/diffview.nvim" },

        -- Commenting
        {
            "numToStr/Comment.nvim",
            lazy = false,
        },

        -- Auto-closing pairs
        {
            "windwp/nvim-autopairs",
            config = function()
                require("nvim-autopairs").setup()
            end,
        },

        -- Surrounding text objects
        {
            "kylechui/nvim-surround",
            version = "*", -- Use for stability with lazy.nvim
            event = "VeryLazy",
            config = function()
                require("nvim-surround").setup()
            end,
        },

        -- Alignment
        {
            "echasnovski/mini.align",
            config = function()
                require("mini.align").setup()
            end,
        },

        -- Show code context
        {
            "nvim-treesitter/nvim-treesitter-context",
            keys = {
                { "<leader>cc", '<cmd>TSContext toggle<cr>', desc = "Toggle code context", },
            },
            config = function()
                require("treesitter-context").setup({
                    enable = false,
                    mode = "topline",
                    max_lines = 5
                })
                vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true })
            end,
        },

        -- tmux
        {
            "vimpostor/vim-tpipeline",
            event = "VeryLazy"
        },
        { "christoomey/vim-tmux-navigator" },

        -- Smooth scrolling
        {
            "karb94/neoscroll.nvim",
            config = function ()
                require('neoscroll').setup({
                    mappings = {                 -- Keys to be mapped to their corresponding default scrolling animation
                        '<C-u>', '<C-d>',
                        'zt', 'zz', 'zb',
                    },
                    hide_cursor = true,          -- Hide cursor while scrolling
                    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
                    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
                    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
                    duration_multiplier = 0.2,   -- Global duration multiplier
                    easing = 'cubic',            -- Default easing function
                    pre_hook = nil,              -- Function to run before the scrolling animation starts
                    post_hook = nil,             -- Function to run after the scrolling animation ends
                    performance_mode = false,    -- Disable "Performance Mode" on all buffers.
                    ignored_events = {           -- Events ignored while scrolling
                        'WinScrolled', 'CursorMoved'
                    },
                })
            end
        },

        -- AI
        {
            "yetone/avante.nvim",
            build = "make",
            event = "VeryLazy",
            version = false, -- Never set this value to "*"! Never!
            ---@module 'avante'
            ---@type avante.Config
            keys = {
                {
                    "<leader>a+",
                    function()
                        local tree_ext = require("avante.extensions.nvim_tree")
                        tree_ext.add_file()
                    end,
                    desc = "Select file in NvimTree",
                    ft = "NvimTree",
                },
                {
                    "<leader>a-",
                    function()
                        local tree_ext = require("avante.extensions.nvim_tree")
                        tree_ext.remove_file()
                    end,
                    desc = "Deselect file in NvimTree",
                    ft = "NvimTree",
                },
            },
            opts = {
                provider = "claude",
                windows = {
                    width = 40
                },
                providers = {
                    copilot = {
                        model = "claude-sonnet-4.6"
                    },
                    claude = {
                        model = "claude-sonnet-4.6"
                    }
                }
            },
            dependencies = {
                "nvim-lua/plenary.nvim",
                "MunifTanjim/nui.nvim",
            },
        }
    },
})

-- Colorscheme
vim.cmd.colorscheme("gruvbox")
vim.api.nvim_set_hl(0, "Visual", { bg = '#ebdbb2', fg = '#222222' })

vim.api.nvim_set_hl(0, "AvanteSidebarNormal", { bg = '#202020' })
vim.api.nvim_set_hl(0, "AvantePromptInput",   { bg = '#202020' })

-- Highlight user prompts (rendered as blockquotes) in cyan in Avante chat history
vim.api.nvim_create_autocmd("FileType", {
    pattern = "Avante",
    callback = function()
        vim.api.nvim_set_hl(0, "@markup.quote", { fg = '#56b6c2', bold = true })
    end,
})

