local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Run PackerCompile if there are changes in this file
-- vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
local packer_grp = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
vim.api.nvim_create_autocmd(
        { "BufWritePost" },
        { pattern = "plugins.lua", command = "source <afile> | PackerSync", group = packer_grp }
)

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "single" }
        end,
    },
}

-- Plugins
return packer.startup(function(use)
    use { "wbthomason/packer.nvim" }

    -- Performance
    use {
        "lewis6991/impatient.nvim",
        config = function()
            require("impatient").enable_profile()
        end,
    }

    -- Load only when require
    use { "nvim-lua/plenary.nvim", module = "plenary" }

    -- Notification
    use {
        "rcarriga/nvim-notify",
        event = "BufReadPre",
        config = function()
            require("config.notify").setup()
        end,
    }

    -- Colorscheme
    use {
        "folke/tokyonight.nvim",
        config = function()
            vim.g.tokyonight_transparent = true
            vim.g.tokyonight_transparent_sidebar = true
            vim.cmd "colorscheme tokyonight "
        end,
        disable = true,
    }
    use {
        "sainnhe/everforest",
        config = function()
            vim.g.everforest_better_performance = 1
            vim.g.everforest_transparent_background = 1
            vim.cmd "colorscheme everforest"
        end,
        disable = false,
    }

    -- Startup screen
    use {
        "goolord/alpha-nvim",
        config = function()
            require("user.alpha").setup()
        end,
    }

    -- Doc
    use { "milisims/nvim-luaref", event = "BufReadPre" }

    -- Git
    use { "f-person/git-blame.nvim", cmd = { "GitBlameToggle" } }

    -- WhichKey
    use {
        "folke/which-key.nvim",
        event = "VimEnter",
        config = function()
            require("config.whichkey").setup()
        end,
    }

    -- IndentLine
    use {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        config = function()
            require("user.indentblankline").setup()
        end,
    }

    -- Better icons
    use {
        "kyazdani42/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup { default = true }
        end,
    }

    -- Better Commentlspconfig
    use {
        "numToStr/Comment.nvim",
        keys = { "gc", "gcc", "gbc" },
        config = function()
            require("user.comment").setup()
        end,
    }

    -- Better surround
    use { "tpope/vim-surround", event = "BufReadPre" }

    -- Motions
    use { "andymass/vim-matchup", event = "CursorMoved" }
    use { "wellle/targets.vim", event = "CursorMoved" }
    use { "unblevable/quick-scope", event = "CursorMoved" }

    -- Buffer
    use { "kazhala/close-buffers.nvim", cmd = { "BDelete", "BWipeout" } }
    use {
        "chentoast/marks.nvim",
        event = "BufReadPre",
        config = function()
            require("marks").setup {}
        end,
    }

    -- IDE
    use {
        "antoinemadec/FixCursorHold.nvim",
        event = "BufReadPre",
        config = function()
            vim.g.cursorhold_updatetime = 100
        end,
    }
    use {
        "karb94/neoscroll.nvim",
        event = "BufReadPre",
        config = function()
            require("user.neoscroll").setup()
        end,
    }
    use { "google/vim-searchindex", event = "BufReadPre" }
    use { "tyru/open-browser.vim", event = "BufReadPre" }

    -- Code documentation
    use {
        "danymat/neogen",
        config = function()
            require("config.neogen").setup()
        end,
        cmd = { "Neogen" },
        module = "neogen",
    }

    use {
        "kkoomen/vim-doge",
        run = ":call doge#install()",
        config = function()
            require("user.doge").setup()
        end,
        cmd = { "DogeGenerate", "DogeCreateDocStandard" },
    }

    -- Jumps
    use {
        "ggandor/leap.nvim",
        keys = { "s", "S", "f", "F", "t", "T" },
        config = function()
            local leap = require "leap"
            leap.set_default_keymaps()
        end,
    }
    use { "AndrewRadev/splitjoin.vim", keys = { "gS", "gJ" } }

    -- Markdown
    use {
        "iamcco/markdown-preview.nvim",
        opt = true,
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
        ft = "markdown",
        cmd = { "MarkdownPreview" },
        requires = { "zhaozg/vim-diagram", "aklt/plantuml-syntax" },
    }
    use {
        "jakewvincent/mkdnflow.nvim",
        rocks = 'luautf8',
        config = function()
            require("mkdnflow").setup {}
        end,
        ft = "markdown",
    }
    -- Status line
    use {
        "nvim-lualine/lualine.nvim",
        event = "BufReadPre",
        after = "nvim-treesitter",
        config = function()
            require("user.lualine").setup()
        end,
    }

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        opt = true,
        event = "BufReadPre",
        run = ":TSUpdate",
        config = function()
            require("user.treesitter").setup()
        end,
        requires = {
            { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPre" },
            { "windwp/nvim-ts-autotag", event = "InsertEnter" },
            { "JoosepAlviste/nvim-ts-context-commentstring", event = "BufReadPre" },
            { "p00f/nvim-ts-rainbow", event = "BufReadPre" },
            { "RRethy/nvim-treesitter-textsubjects", event = "BufReadPre" },
        },
    }

    use {
        "nvim-telescope/telescope.nvim",
        opt = true,
        config = function()
            require("user.telescope").setup()
        end,
        cmd = { "Telescope" },
        module = { "telescope", "telescope.builtin" },
        keys = { "<leader>f", "<leader>p", "<leader>z" },
        requires = {
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
            "nvim-telescope/telescope-project.nvim",
            "cljoly/telescope-repo.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            { "nvim-telescope/telescope-frecency.nvim", requires = "tami5/sqlite.lua" },
            {
                "ahmedkhalf/project.nvim",
                config = function()
                    require("user.project").setup()
                end,
            },
            "nvim-telescope/telescope-dap.nvim",
            "nvim-telescope/telescope-smart-history.nvim",
            {
                "nvim-telescope/telescope-arecibo.nvim",
                rocks = { "openssl", "lua-http-parser" },
            },
            "nvim-telescope/telescope-media-files.nvim",
            "dhruvmanila/telescope-bookmarks.nvim",
            "nvim-telescope/telescope-github.nvim",
            "jvgrootveld/telescope-zoxide",
            "Zane-/cder.nvim",
        },
    }

    -- nvim-tree
    use {
        "kyazdani42/nvim-tree.lua",
        opt = true,
        cmd = { "NvimTreeToggle", "NvimTreeClose" },
        config = function()
            require("user.nvimtree").setup()
        end,
    }

    -- Buffer line
    use {
        "akinsho/nvim-bufferline.lua",
        event = "BufReadPre",
        config = function()
            require("user.bufferline").setup()
        end,
    }

    -- User interface
    use {
        "stevearc/dressing.nvim",
        event = "BufReadPre",
        config = function()
            require("dressing").setup {
                input = { relative = "editor" },
                select = {
                    backend = { "telescope", "fzf", "builtin" },
                },
            }
        end,
    }

    -- Completion
    use {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        opt = true,
        config = function()
            require("user.cmp").setup()
        end,
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "ray-x/cmp-treesitter",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
            "honza/vim-snippets",
        },
    }

    -- Auto pairs
    use {
        "windwp/nvim-autopairs",
        opt = true,
        event = "InsertEnter",
        module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
        config = function()
            require("user.autopairs").setup()
        end,
    }

    -- Auto tag
    use {
        "windwp/nvim-ts-autotag",
        opt = true,
        event = "InsertEnter",
        config = function()
            require("nvim-ts-autotag").setup { enable = true }
        end,
    }

    -- End wise
    use {
        "RRethy/nvim-treesitter-endwise",
        opt = true,
        event = "InsertEnter",
    }
    -- LSP
    use {
        "SmiteshP/nvim-navic",
        config = function()
            require("nvim-navic").setup {}
        end,
    }

    use {
         "williamboman/mason.nvim",
         require("mason").setup(),
    }

    use {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        require("mason-lspconfig").setup({
            ensure_installed = { "sumneko_lua", "rust_analyzer" }
        }),
    }

    use {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opt = true,
        event = { "BufReadPre" },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "sumneko_lua", "rust_analyzer" }
            })
            require("config.lsp").setup()
            require('mason-tool-installer').setup {
            }
        end,
    }
    use {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup {}
        end,
    }

    use {
        "jose-elias-alvarez/null-ls.nvim",
        "jayp0521/mason-null-ls.nvim",
        "folke/lua-dev.nvim",
        "RRethy/vim-illuminate",
        "b0o/schemastore.nvim",
        "jose-elias-alvarez/typescript.nvim",

        config = function()
            require("mason").setup()
            require("null-ls").setup()
            require("mason-null-ls").setup()
        end,
         requires = {
        },

    }
    -- trouble.nvim
    use {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        config = function()
            require("trouble").setup {
                use_diagnostic_signs = true,
            }
        end,
    }

    -- lspsaga.nvim
    use {
        "glepnir/lspsaga.nvim",
        cmd = { "Lspsaga" },
        config = function()
            require("lspsaga").init_lsp_saga()
        end,
    }

    -- renamer.nvim
    use {
        "filipdutescu/renamer.nvim",
        module = { "renamer" },
        config = function()
            require("renamer").setup {}
        end,
    }

    -- Rust
    use {
        "simrat39/rust-tools.nvim",
        branch = "modularize_and_inlay_rewrite",
        requires = { "nvim-lua/plenary.nvim", "rust-lang/rust.vim" },
        opt = true,
        module = "rust-tools",
        ft = { "rust" },
    }
    use {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            -- local null_ls = require "null-ls"
            require("crates").setup {
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                },
            }
        end,
    }

    -- Java
    use { "mfussenegger/nvim-jdtls", ft = { "java" } }

    -- Flutter
    use {
        "akinsho/flutter-tools.nvim",
        ft = { "dart", "yaml" },
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("config.flutter").setup()
        end,
    }

    -- Terminal
    use {
        "akinsho/toggleterm.nvim",
        config = function()
            require("user.toggleterm").setup()
        end,
    }
    use {
        "theHamsta/nvim-dap-virtual-text",
    }
    -- Debugging
    use {
        "mfussenegger/nvim-dap",
        opt = true,
        keys = { [[<leader>d]] },
        module = { "dap" },
        requires = {
            "theHamsta/nvim-dap-virtual-text",
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap-python",
            "nvim-telescope/telescope-dap.nvim",
            { "leoluz/nvim-dap-go", module = "dap-go" },
            { "jbyuki/one-small-step-for-vimkind", module = "osv" },
        },
        config = function()
            require("config.dap").setup()
        end,
    }

    -- Test
    use { "diepm/vim-rest-console", ft = { "rest" } }
    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-plenary",
            "nvim-neotest/neotest-go",
            "haydenmeade/neotest-jest",
            "nvim-neotest/neotest-vim-test",
            "sidlatau/neotest-dart",
            "rouge8/neotest-rust",
            "vim-test/vim-test",
        },
        keys = { [[<leader>t]] },
        module = { "neotest" },
        config = function()
            require("config.neotest").setup()
        end,
    }

    -- Legendary
    use {
        "mrjones2014/legendary.nvim",
        opt = true,
        keys = { [[<C-p>]] },
        module = { "legendary" },
        cmd = { "Legendary" },
        config = function()
            require("user.legendary").setup()
        end,
    }

    -- Refactoring
    use {
        "ThePrimeagen/refactoring.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" },
        },
        module = { "refactoring", "telescope" },
        keys = { [[<leader>r]] },
        config = function()
            require("config.refactoring").setup()
        end,
    }
    use {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        config = function()
            require("bqf").setup()
        end,
    }
    use { "nvim-pack/nvim-spectre", module = "spectre", keys = { "<leader>s" } }
    use {
        "kevinhwang91/nvim-ufo",
        opt = true,
        keys = { "zc", "zo", "zC", "zO" },
        requires = "kevinhwang91/promise-async",
        config = function()
            require("ufo").setup {
                provider_selector = function(_, _)
                    return { "lsp", "treesitter", "indent" }
                end,
            }
            vim.keymap.set("n", "zO", require("ufo").openAllFolds)
            vim.keymap.set("n", "zC", require("ufo").closeAllFolds)
        end,
    }

    -- Performance
    use { "dstein64/vim-startuptime", cmd = "StartupTime" }
    use { "nathom/filetype.nvim" ,
        config = function()
            -- In init.lua or filetype.nvim's config file
            require("filetype").setup({
                overrides = {
                    extensions = {
                        -- Set the filetype of *.pn files to potion
                        pn = "potion",
                    },
                    literal = {
                        -- Set the filetype of files named "MyBackupFile" to lua
                        MyBackupFile = "lua",
                    },
                    complex = {
                        -- Set the filetype of any full filename matching the regex to gitconfig
                        [".*git/config"] = "gitconfig", -- Included in the plugin
                    },

                    -- The same as the ones above except the keys map to functions
                    function_extensions = {
                        ["cpp"] = function()
                            vim.bo.filetype = "cpp"
                            -- Remove annoying indent jumping
                            vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
                        end,
                        ["pdf"] = function()
                            vim.bo.filetype = "pdf"
                            -- Open in PDF viewer (Skim.app) automatically
                            vim.fn.jobstart(
                                "open -a skim " .. '"' .. vim.fn.expand("%") .. '"'
                            )
                        end,
                    },
                    function_literal = {
                        Brewfile = function()
                            vim.cmd("syntax off")
                        end,
                    },
                    function_complex = {
                        ["*.math_notes/%w+"] = function()
                            vim.cmd("iabbrev $ $$")
                        end,
                    },

                    shebang = {
                        -- Set the filetype of files with a dash shebang to sh
                        dash = "sh",
                    },
                },
            })
        end,
    }

    -- Web
    use {
        "vuki656/package-info.nvim",
        branch = "develop",
        opt = true,
        requires = {
            "MunifTanjim/nui.nvim",
        },
        module = { "package-info" },
        ft = { "json" },
        config = function()
            require("config.package").setup()
        end,
    }
    -- Session
    use {
        "rmagatti/auto-session",
        opt = true,
        cmd = { "SaveSession", "RestoreSession" },
        requires = { "rmagatti/session-lens" },
    }

    -- Plugin
    use {
        "tpope/vim-scriptease",
        cmd = {
            "Messages", --view messages in quickfix list
            "Verbose", -- view verbose output in preview window.
            "Time", -- measure how long it takes to run some stuff.
        },
        event = "BufReadPre",
    }

    -- Todo
    use {
        "folke/todo-comments.nvim",
        config = function()
            require("config.todocomments").setup()
        end,
        cmd = { "TodoQuickfix", "TodoTrouble", "TodoTelescope" },
    }

    -- Diffview
    use {
        "sindrets/diffview.nvim",
        requires = "nvim-lua/plenary.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles" },
    }

    -- Translation
    use {
        "voldikss/vim-translator",
        cmd = { "Translate", "TranslateV", "TranslateW", "TranslateWV", "TranslateR", "TranslateRV", "TranslateX" },
        config = function()
            vim.g.translator_target_lang = "zh"
            vim.g.translator_history_enable = true
        end,
    }

    -- Task runner
    use {
        "stevearc/overseer.nvim",
        opt = true,
        cmd = { "OverseerToggle", "OverseerRun", "OverseerBuild" },
        config = function()
            require("overseer").setup()
        end,
    }

    -- Testing
    use {
        "m-demare/attempt.nvim",
        opt = true,
        requires = "nvim-lua/plenary.nvim",
        module = { "attempt" },
        keys = { "<leader>a" },
        config = function()
            require("user.attempt").setup()
        end,
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
