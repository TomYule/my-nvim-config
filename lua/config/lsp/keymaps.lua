local M = {}

local whichkey = require "which-key"
local legendary = require "legendary"

-- local keymap = vim.api.nvim_set_keymap
-- local buf_keymap = vim.api.nvim_buf_set_keymap
local keymap = vim.keymap.set

local function keymappings(client, bufnr)
  local opts = { noremap = true, silent = true }

  -- Key mappings
  keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

  keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
  keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
  keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap("n", "gs", "<Cmd>Lspsaga signature_help<CR>", opts)

  -- Whichkey
  local keymap_l = {
    l = {
      name = "LSP",
      R = { "<cmd>Trouble lsp_references<cr>", "Trouble References" },
      a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
      d = { "<cmd>Telescope diagnostics<CR>", "Diagnostics" },
      f = { "<cmd>Lspsaga lsp_finder<CR>", "Finder" },
      i = { "<cmd>LspInfo<CR>", "Lsp Info" },
      r = { "<cmd>lua require('renamer').rename()<CR>", "Rename" },

      s = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
      t = { "<cmd>TroubleToggle document_diagnostics<CR>", "Trouble" },
      L = { "<cmd>lua vim.lsp.codelens.refresh()<CR>", "Refresh CodeLens" },
      l = { "<cmd>lua vim.lsp.codelens.run()<CR>", "Run CodeLens" },
      D = { "<cmd>lua require('config.lsp').toggle_diagnostics()<CR>", "Toggle Inline Diagnostics" },
      o = { "<cmd>LSoutlineToggle<CR>", "Toggle Outline" },
    },
  }
  if client.server_capabilities.documentFormattingProvider then
    keymap_l.l.F = { "<cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format Document" }
  end

  local keymap_g = {
    name = "Goto",
    d = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
    D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
    h = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
    I = { "<cmd>Telescope lsp_implementations<CR>", "Goto Implementation" },
    b = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
  }

  local keymap_v_l = {
    l = {
      name = "LSP",
      a = { "<cmd>'<,'>lua vim.lsp.buf.range_code_action()<CR>", "Code Action" },
    },
  }

  local o = { buffer = bufnr, prefix = "<leader>" }
  whichkey.register(keymap_l, o)
  legendary.bind_whichkey(keymap_l, o, false)

  o = { mode = "v", buffer = bufnr, prefix = "<leader>" }
  whichkey.register(keymap_v_l, o)
  legendary.bind_whichkey(keymap_v_l, o, false)

  o = { buffer = bufnr, prefix = "g" }
  whichkey.register(keymap_g, o)
  legendary.bind_whichkey(keymap_g, o, false)
end

function M.setup(client, bufnr)
  keymappings(client, bufnr)
end

return M
