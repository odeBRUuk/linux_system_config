-- "¯\_(ツ)_/¯"
-- Most of this was taken from TJ DeVries' kickstart.nvim found at:
--      << github.com/nvim-lua/kickstart.nvim >>
-- Set space as `leader` key
-- Must come before plugins are used
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Nerd Fonts need to be installed; change to false if this doesn't work
vim.g.have_nerd_font = true

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- [A]llow mouse
vim.opt.mouse = "a"

vim.opt.showmode = true

-- allow neovim to use OS clipboard
vim.opt.clipboard = "unnamedplus"

-- indent with linebreak
vim.opt.breakindent = true

-- save undo history
vim.opt.undofile = true

-- case-insensitive search, unless \C is used
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- keep signcolumn on
vim.opt.signcolumn = "yes"

-- decrease update time
vim.opt.updatetime = 250

-- decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- new split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- certain whitespace characters display behavior
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- live substitutions preview
vim.opt.inccommand = "split"

-- highlight line cursor is on
vim.opt.cursorline = true

-- minimum number of screen lines to keep above/below cursor
vim.opt.scrolloff = 10

-- add small hack for vertical ruler
vim.opt.colorcolumn = "80"

-- 'termguicolors' enables all the neat terminal GUI colorschemes I love so much
vim.cmd.set("termguicolors")

-- [[ BASIC KEYMAPS ]]
-- highlight search, then clear (normal mode)
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- diagnostics, bound to diagnostic menu option
vim.keymap.set("n", "<leader>ep", vim.diagnostic.goto_prev, { desc = "[E]rrors: [P]revious error message" })
vim.keymap.set("n", "<leader>en", vim.diagnostic.goto_next, { desc = "[E]rrors: [N]ext error message" })
vim.keymap.set("n", "<leader>ef", vim.diagnostic.open_float, { desc = "[E]rrors: [F]loating menu" })
vim.keymap.set("n", "<leader>eq", vim.diagnostic.setloclist, { desc = "[E]rrors: [Q]uickfix menu" })

-- exit terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Disabled arrow keys :)
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move left :)"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move right :)"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move up :)"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move down :)"<CR>')

-- move between windows faster
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to right window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to above window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to below window" })

-- toggle indentation type, tabs or spaces
vim.keymap.set(
    "n",
    "<leader>ti",
    function()
        vim.cmd.set("expandtab!")
    end, -- function
    { desc = "[T]oggle [I]ndentation type (tabs/spaces)" }
)

-- [[ BASIC AUTOCOMMANDS ]]
-- Highlight yanked/copied text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking/copying text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Set tabstop, shiftwidth, etc depending on file type
-- extensions that require a change
local changeExt = {
    ["sh"] = 1,
    ["shl"] = 1,
    ["js"] = 2,
    ["ts"] = 2,
    ["jsx"] = 2,
    ["tsx"] = 2,
}

-- commands to run if the file name exists in above tables
local language_table = {
    -- use 4-char tabs
    [1] = { "noexpandtab", "tabstop=4", "shiftwidth=0" },
    -- use 2-char spaces
    [2] = { "expandtab", "tabstop=2", "shiftwidth=2" },
    -- all others, 4-space expanded tabs, default values
    ["default"] = { "expandtab", "shiftwidth=4", "tabstop=4" },
}

-- Determine tabs/spaces and length depending on file name
vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Change tabstop/shiftwidth settings depending on filetype",
    group = vim.api.nvim_create_augroup("detect-tabstop", {}),
    callback = function()
        local ext = vim.fn.expand("%:e") -- get file extension (minus `.`)

        local table_index = changeExt[ext] or "default"

        -- run commands
        for _, command in ipairs(language_table[table_index]) do
            vim.cmd.set(command)
        end
    end, -- callback
})

-- Remove auto-comment when adding a newline at the end of a commented line
vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- [[ Use lazy.nvim plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
-- useful commands:
-- :Lazy - current plugin status
-- :Lazy update - update plugins
require("lazy").setup({
    -- web devicons for several plugins
    {
        "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup({})
        end, -- config
    },

    -- quickly comment
    -- important keybinds (normal mode):
    -- gcc - line comment
    -- gbc - block comment
    { "numToStr/Comment.nvim", opts = {}, lazy = false },

    -- gitsigns provide signs to gutter for managing changes
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },

    -- shows pending keybinds
    {
        "folke/which-key.nvim",
        event = "VimEnter", -- load when program is entered
        config = function() -- config runs after load
            local which = require("which-key")
            which.setup()
            -- Add keybinds
            which.add({
                { "<leader>b",  group = "[B]reakpoint" },
                { "<leader>b_", hidden = true },
                { "<leader>c",  group = "[C]ode" },
                { "<leader>c_", hidden = true },
                { "<leader>e",  group = "[E]rrors" },
                { "<leader>e_", hidden = true },
                { "<leader>r",  group = "[R]ename" },
                { "<leader>r_", hidden = true },
                { "<leader>s",  group = "[S]earch" },
                { "<leader>s_", hidden = true },
                { "<leader>w",  group = "[W]orkspace" },
                { "<leader>w_", hidden = true },
                { "<leader>t",  group = "[T]oggle" },
                { "<leader>t_", hidden = true },
                { "<leader>f",  group = "[F]ile" },
                { "<leader>f_", hidden = true },
            })
        end,
    },

    -- fuzzy finder (searches EVERYTHING)
    -- important keybinds:
    --  <C-/> insert mode find
    --  ? normal mode find
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                -- determine if plugin should be loaded
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-tree/nvim-web-devicons",            enabled = vim.g.have_nerd_font },
        },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
            vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
            vim.keymap.set("n", "<leader>s", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

            vim.keymap.set("n", "<leader>/", function()
                -- can change themes
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    winblend = 10,
                    previewer = false,
                }))
            end, { desc = "[/] Fuzzily search in current buffer" })

            vim.keymap.set("n", "<leader>s/", function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                })
            end, { desc = "[S]earch [/] in Open Files" })

            -- search neovim config files
            vim.keymap.set("n", "<leader>sn", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "[S]earch [N]eovim files" })
        end, -- config
    }, -- telescope

    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            -- install LSP and related tools to stdpath
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Status updates for LSP
            { "j-hui/fidget.nvim", opts = {} },

            -- Lua LSP
            { "folke/neodev.nvim", opts = {} },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                -- Languiage Server Protocol
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    local builtin = require("telescope.builtin")

                    -- Helper to define LSP-related functions
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    -- Jump to definition
                    map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")

                    -- Find references under cursor
                    map("gr", builtin.lsp_references, "[G]oto [R]eferences")

                    -- Jump to implementation
                    map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")

                    -- Jump to definition of type
                    map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
                    -- Fzf all symbols in current document
                    map("<leader>fs", builtin.lsp_document_symbols, "[F]ile [S]ymbols")

                    -- Fzf sumbols in current workspace
                    map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

                    -- rename variable underneath cursor
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

                    -- allow for code action, such as correcting an error
                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

                    -- display documentation of word under cursor
                    -- `:help K` to view reason for this keybind
                    map("K", vim.lsp.buf.hover, "Hover Documentation")

                    -- view declaration, not definition, of item
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    -- TODO: Add code to add an enable/disabled keybind for a 
                    -- true 'learning mode'

                    -- highlight words like the one under cursor, clear when move
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHightlightProvider then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end -- if client
                end, -- callback
            })

            -- create additional capabilites with nvim-cmp, luasnap, etc
            local capabilites = vim.lsp.protocol.make_client_capabilities()
            capabilites = vim.tbl_deep_extend("force", capabilites, require("cmp_nvim_lsp").default_capabilities())

            local servers = {
                clangd = {},
                gopls = {},
                rust_analyzer = {},
                -- Was causing some warnings, wanted them to go away - RO 
                -- 10/28/24
                -- tsserver = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
                html = {},
                jsonls = {},
                ols = {},
                sqlls = {},
                volar = {},
            } -- servers

            require("mason").setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}

                        server.capabilites = vim.tbl_deep_extend("force", {}, capabilites, server.capabilites or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })

            -- Add code to disable on startup, but also add an easy-to-remember
            -- command to enable/disable autocompletion
        end, -- config
    }, -- LSP

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        lazy = false,
        dependencies = {
            -- snippet engine and associated source
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    -- build step for regex
                    -- not supported in windows environments
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end -- if
                    return "make install_jsregexp"
                end)(), -- build
                dependencies = {
                    -- friend
                },
            },
            "saadparwaiz1/cmp_luasnip",

            -- Adds other completion capabilites
            -- Split into several repos for maintainability
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
        },
        config = function()
            -- `:help cmp`
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end, -- expand
                },
                completion = { completeopt = "menu,menuone,noinsert" },

                -- `:help ins-completion`
                -- changed from `cmp.mapping.preset.insert` to `cmp.mapping` to
                -- avoid `cmp` using my arrow keys :(
                mapping = cmp.mapping({
                    -- [N]ext item
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    -- [P]revious item
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    -- Scroll documentation [B]ack/[F]orward
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    -- [E]xit autocomplete
                    ["<C-e>"] = cmp.mapping.abort(),

                    -- Confirm completion
                    ["<C-Space>"] = cmp.mapping.confirm({ select = true }),

                    -- Manually trigger completion from nvim-cmp
                    ["<C-y>"] = cmp.mapping.complete({}),

                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --    $body
                    --  end
                    --
                    -- <c-l> will move you to the right of each of the expansion locations.
                    -- <c-h> is similar, except moving you backwards.
                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                },
            })

            -- Add code to disable on startup, but also add an easy-to-remember
            -- command to enable/disable autocompletion
        end, -- config
    },

    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            signs = false,
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "html",
                "css",
                "javascript",
                "typescript",
                "lua",
                "luadoc",
                "markdown",
                "vim",
                "vimdoc",
                "rust",
                "go",
            },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { "ruby" },
            },
            indent = { enable = true, disable = { "ruby" } },
        },
        config = function(_, opts)
            -- `:help nvim-treesitter`
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup(opts)
        end, -- config
    },

    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({}) -- setup
            local api = require("nvim-tree.api")

            vim.keymap.set(
                "n",
                "<leader>tt",
                api.tree.toggle,
                { desc = "[T]oggle Neovim [T]ree", noremap = true, silent = true, nowait = true }
            )
        end, -- config
    },

    -- Fancy status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({})
        end, -- lualine config
    },

    -- Adapters to find:
    -- C++,
    -- C,
    -- Rust,
    -- JS/TS [React],
    -- Lua,

    -- Used for more complex debugging than `print` statements
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "leoluz/nvim-dap-go",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            require("dap-go").setup()
            dapui.setup()

            -- in-debugger keybinds
            vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
            vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
            vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })

            -- out of debugger keybindings
            vim.keymap.set("n", "<leader>bt", dap.toggle_breakpoint, { desc = "[B]reakpoint [T]oggle" })
            vim.keymap.set("n", "<leader>bs", dap.set_breakpoint, { desc = "[B]reakpoint [S]et" })

            -- dap-ui keybinds
            dap.listeners.before.attach.dapui_config = dapui.open
            dap.listeners.before.launch.dapui_config = dapui.open
            dap.listeners.before.event_terminated.dapui_config = dapui.close
            dap.listeners.before.event_exited.dapui_config = dapui.close
        end, -- config
    },

    -- database integration plugin
    {
        "tpope/vim-dadbod",
        config = function() end, -- config
    },

    -- [[ COLORSCHEMES ]]
    {
    	"folke/tokyonight.nvim",
        lazy = true,
    	priority = 1000, -- load before other plugins
    },

    {
        "thedenisnikulin/vim-cyberpunk",
        priority = 1001,
        lazy = false,
        config = function()
            vim.cmd.colorscheme("cyberpunk")
            vim.cmd.hi("Special gui=none")
            vim.cmd.hi("CursorLine guibg=#1c171f guifg=none")
            vim.cmd.hi("Cursor gui=none guifg=#2b3e5a guibg=#00ffc8")
            vim.cmd.hi("IncSearch cterm=reverse guibg=#13b894")
        end,
    },

    {
    	"Zabanaa/neuromancer.vim",
    	priority = 1000,
    	lazy = true
    },

    {
    	"maxmx03/fluoromachine.nvim",
    	priority = 1000,
    	lazy = true,
    	config = function()
    		-- local fm = require("fluoromachine")
    		-- fm.setup({
    		-- 	glow = true,
    		-- 	-- themes: fluoromachine, retrowave, delta
    		-- 	theme = "fluoromachine",
    		-- 	transparent = true,
    		-- })
    	end,
    },

    {
        "cs-cmd/cyberpunk-v2",
        priority = 1000,
        lazy = true,
        config = function()
            -- vim.cmd.colorscheme("cyberpunk-v2")
        end,
    },
},

{
    ui = {
        icons = vim.g.have_nerd_font and {} or {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            require = "🌙",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
})
