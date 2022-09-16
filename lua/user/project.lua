local M = {}

function M.setup()
  require("project_nvim").setup {
    -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
    detection_methods = { "pattern" },
    patterns = { ".git", "Makefile", "package.json" },
    ignore_lsp = { "null-ls" },
    -- silent_chdir = false,
  }
end

return M
