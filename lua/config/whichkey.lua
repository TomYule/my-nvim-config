local M = {}

local whichkey = require("which-key")
local legendary = require("legendary")
local next = next

local conf = {
	window = {
		border = "single", -- none, single, double, shadow
		position = "bottom", -- bottom, top
	},
}
whichkey.setup(conf)

local opts = {
	mode = "n", -- Normal mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

local v_opts = {
	mode = "v", -- Visual mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

local function normal_keymap()
	local keymap_f = nil -- File search
	local keymap_p = nil -- Project search

	keymap_f = {
		name = "Find",
		f = { "<cmd>lua require('utils.finder').find_files()<cr>", "Files" },
		b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffers" },
		h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", "Help" },
		m = { "<cmd>lua require('telescope.builtin').marks()<cr>", "Marks" },
		o = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", "Old Files" },
		g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Live Grep" },
		c = { "<cmd>lua require('telescope.builtin').commands()<cr>", "Commands" },
		r = { "<cmd>lua require'telescope'.extensions.file_browser.file_browser()<cr>", "File Browser" },
		w = { "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", "Current Buffer" },
		e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
	}

	keymap_p = {
		name = "Project",
		p = { "<cmd>lua require('telescope').extensions.projects.projects()<CR>", "List" },
		s = { "<cmd>lua require'telescope'.extensions.repo.list{}<cr>", "Search" },
		P = { "<cmd>TermExec cmd='BROWSER=brave yarn dev'<cr>", "Slidev" },
	}

	local keymap = {
		["w"] = { "<cmd>update!<CR>", "Save" },
		["q"] = { "<cmd>lua require('utils').quit()<CR>", "Quit" },
		["T"] = { "<Cmd>Translate<CR>", "Translate" },
		-- ["t"] = { "<cmd>ToggleTerm<CR>", "Terminal" },

		a = {
			name = "Attempt",
			n = { "<Cmd>lua require('attempt').new_select()<Cr>", "New Select" },
			i = { "<Cmd>lua require('attempt').new_input_ext()<Cr>", "New Input Extension" },
			r = { "<Cmd>lua require('attempt').run()<Cr>", "Run" },
			d = { "<Cmd>lua require('attempt').delete_buf()<Cr>", "Delete Buffer" },
			c = { "<Cmd>lua require('attempt').rename_buf()<Cr>", "Rename Buffer" },
		},

		b = {
			name = "Buffer",
			c = { "<Cmd>BDelete this<Cr>", "Close Buffer" },
			f = { "<Cmd>BDelete! this<Cr>", "Force Close Buffer" },
			D = { "<Cmd>BWipeout other<Cr>", "Delete All Buffers" },
			b = { "<Cmd>BufferLinePick<Cr>", "Pick a Buffer" },
			p = { "<Cmd>BufferLinePickClose<Cr>", "Pick & Close a Buffer" },
		},

		c = {
			name = "Code",
			g = { "<cmd>Neogen func<Cr>", "Func Doc" },
			G = { "<cmd>Neogen class<Cr>", "Class Doc" },
			d = { "<cmd>DogeGenerate<Cr>", "Generate Doc" },
			T = { "<cmd>TodoTelescope<Cr>", "TODO" },
			x = "Swap Next Param",
			X = "Swap Prev Param",
			-- f = "Select Outer Function",
			-- F = "Select Outer Class",
		},

		d = {
			name = "Debug",
		},

		f = keymap_f,
		p = keymap_p,

		t = {
			name = "Neotest",
			a = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach" },
			f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run File" },
			F = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Debug File" },
			l = { "<cmd>lua require('neotest').run.run_last()<cr>", "Run Last" },
			L = { "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>", "Debug Last" },
			n = { "<cmd>lua require('neotest').run.run()<cr>", "Run Nearest" },
			N = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug Nearest" },
			o = { "<cmd>lua require('neotest').output.open({ enter = true })<cr>", "Output" },
			S = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop" },
			s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Summary" },
		},

		r = {
			name = "Refactor",
			i = { [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], "Inline Variable" },
			f = { [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], "Extract Function" },
			v = { [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], "Extract Variable" },
			p = { [[ <Esc><Cmd>lua require('refactoring').debug.printf({below = false})<CR>]], "Debug Print" },
			c = { [[ <Esc><Cmd>lua require('refactoring').debug.cleanup({below = false})<CR>]], "Debug Cleanup" },
		},

		s = {
			name = "Search",
			o = { [[ <Esc><Cmd>lua require('spectre').open()<CR>]], "Open" },
		},

		z = {
			name = "System",
			d = { "<cmd>DiffviewOpen<cr>", "Diff View Open" },
			D = { "<cmd>DiffviewClose<cr>", "Diff View Close" },
			i = { "<cmd>PackerInstall<cr>", "Install" },
			p = { "<cmd>PackerProfile<cr>", "Profile" },
			s = { "<cmd>PackerSync<cr>", "Sync" },
			S = { "<cmd>PackerStatus<cr>", "Status" },
			u = { "<cmd>PackerUpdate<cr>", "Update" },
			x = { "<cmd>Telescope cder<cr>", "Change Directory" },
			e = { "!!$SHELL<CR>", "Execute line" },
			W = { "<cmd>lua require('utils.session').toggle_session()<cr>", "Toggle Workspace Saving" },
			w = { "<cmd>lua require('utils.session').list_session()<cr>", "Restore Workspace" },
			z = { "<cmd>lua require'telescope'.extensions.zoxide.list{}<cr>", "Zoxide" },
		},

		g = {
			name = "Git",
			b = { "<cmd>GitBlameToggle<CR>", "Blame" },
			z = { "<cmd>lua require('utils.term').git_client_toggle()<CR>", "Git TUI" },
		},

    x = {
      name = "External",
      p = { "<cmd>lua require('utils.term').project_info_toggle()<CR>", "Project Info" },
      s = { "<cmd>lua require('utils.term').system_info_toggle()<CR>", "System Info" },
      c = { "<cmd>lua require('utils.term').cht()<CR>", "Cheatsheet" },
      i = { "<cmd>lua require('utils.term').interactive_cheatsheet_toggle()<CR>", "Interactive Cheatsheet" },
    },
	}
	whichkey.register(keymap, opts)
	legendary.bind_whichkey(keymap, opts, false)
end

local function visual_keymap()
	local keymap = {
		r = {
			name = "Refactor",
			e = { [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], "Extract Function" },
			f = {
				[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function to File')<CR>]],
				"Extract Function to File",
			},
			v = { [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], "Extract Variable" },
			i = { [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], "Inline Variable" },
			r = { [[ <Esc><Cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]], "Refactor" },
			V = { [[ <Esc><Cmd>lua require('refactoring').debug.print_var({})<CR>]], "Debug Print Var" },
		},
	}

	whichkey.register(keymap, v_opts)
	legendary.bind_whichkey(keymap, v_opts, false)
end

local function code_keymap()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "*",
		callback = function()
			vim.schedule(CodeRunner)
		end,
	})

	function CodeRunner()
		local bufnr = vim.api.nvim_get_current_buf()
		local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
		local fname = vim.fn.expand("%:p:t")
		local keymap_c = {} -- normal key map
		local keymap_c_v = {} -- visual key map

		if ft == "python" then
			keymap_c = {
				name = "Code",
				r = { "<cmd>update<CR><cmd>exec '!python3' shellescape(@%, 1)<cr>", "Run" },
				m = { "<cmd>TermExec cmd='nodemon -e py %'<cr>", "Monitor" },
			}
		elseif ft == "lua" then
			keymap_c = {
				name = "Code",
				r = { "<cmd>luafile %<cr>", "Run" },
			}
		elseif ft == "rust" then
			keymap_c = {
				name = "Code",
				r = { "<cmd>execute 'Cargo run' | startinsert<cr>", "Run" },
				D = { "<cmd>RustDebuggables<cr>", "Debuggables" },
				h = { "<cmd>RustHoverActions<cr>", "Hover Actions" },
				R = { "<cmd>RustRunnables<cr>", "Runnables" },
			}
		elseif ft == "go" then
			keymap_c = {
				name = "Code",
				r = { "<cmd>GoRun<cr>", "Run" },
			}
		elseif ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
			keymap_c = {
				name = "Code",
				o = { "<cmd>TypescriptOrganizeImports<cr>", "Organize Imports" },
				r = { "<cmd>TypescriptRenameFile<cr>", "Rename File" },
				i = { "<cmd>TypescriptAddMissingImports<cr>", "Import Missing" },
				F = { "<cmd>TypescriptFixAll<cr>", "Fix All" },
				u = { "<cmd>TypescriptRemoveUnused<cr>", "Remove Unused" },
			}
		elseif ft == "java" then
			keymap_c = {
				name = "Code",
				o = { "<cmd>lua require'jdtls'.organize_imports()<cr>", "Organize Imports" },
				v = { "<cmd>lua require('jdtls').extract_variable()<cr>", "Extract Variable" },
				c = { "<cmd>lua require('jdtls').extract_constant()<cr>", "Extract Constant" },
				t = { "<cmd>lua require('jdtls').test_class()<cr>", "Test Class" },
				n = { "<cmd>lua require('jdtls').test_nearest_method()<cr>", "Test Nearest Method" },
			}
			keymap_c_v = {
				name = "Code",
				v = { "<cmd>lua require('jdtls').extract_variable(true)<cr>", "Extract Variable" },
				c = { "<cmd>lua require('jdtls').extract_constant(true)<cr>", "Extract Constant" },
				m = { "<cmd>lua require('jdtls').extract_method(true)<cr>", "Extract Method" },
			}
		elseif ft == "dart" then
			keymap_c = {
				name = "Code",
				r = { "<cmd>FlutterReload<cr>", "Flutter Hot Reload" },
				R = { "<cmd>FlutterRestart<cr>", "Flutter Hot Restart" },
			}
		end

		if fname == "package.json" then
			keymap_c.v = { "<cmd>lua require('package-info').show()<cr>", "Show Version" }
			keymap_c.c = { "<cmd>lua require('package-info').change_version()<cr>", "Change Version" }
		end

		if fname == "Cargo.toml" then
			keymap_c.u = { "<cmd>lua require('crates').upgrade_all_crates()<cr>", "Upgrade All Crates" }
		end

		-- overseer.nvim
		keymap_c.s = { "<cmd>OverseerRun<cr>", "Overseer Run" }
		keymap_c.S = { "<cmd>OverseerToggle!<cr>", "Overseer Toggle" }
		keymap_c.a = { "<cmd>OverseerQuickAction<cr>", "Overseer Quick Action" }
		keymap_c.A = { "<cmd>OverseerTaskAction<cr>", "Overseer Task Action" }

		if next(keymap_c) ~= nil then
			local k = { c = keymap_c }
			local o = { mode = "n", silent = true, noremap = true, buffer = bufnr, prefix = "<leader>", nowait = true }
			whichkey.register(k, o)
			legendary.bind_whichkey(k, o, false)
		end

		if next(keymap_c_v) ~= nil then
			local k = { c = keymap_c_v }
			local o = { mode = "v", silent = true, noremap = true, buffer = bufnr, prefix = "<leader>", nowait = true }
			whichkey.register(k, o)
			legendary.bind_whichkey(k, o, false)
		end
	end
end

function M.setup()
	normal_keymap()
	visual_keymap()
	code_keymap()
end

return M
