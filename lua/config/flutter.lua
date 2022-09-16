local M = {}

function M.setup()
  require("flutter-tools").setup {
    debugger = {
      enabled = true,
      run_via_dap = true,
    },
    outline = { auto_open = false },
    widget_guides = { enabled = true },
    dev_log = { enabled = false, open_cmd = "tabedit" },
    fvm = true,
    lsp = {
      color = {
        enabled = true,
        background = true,
        virtual_text = false,
      },
      settings = {
        showTodos = true,
        renameFilesWithClasses = "prompt",
        enableSnippets = true,
        analysisExcludedFolders = {
          vim.fn.expand "$HOME/.pub-cache",
          vim.fn.expand "$HOME/fvm",
        },
      },
      on_attach = require("config.lsp").on_attach,
      capabilities = require("config.lsp").capabilities,
    },
  }
end

return M
