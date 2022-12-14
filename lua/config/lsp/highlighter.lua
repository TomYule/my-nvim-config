local M = {}

local api = vim.api

function M.highlight(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    local present, illuminate = pcall(require, "illuminate")
    if present then
      illuminate.on_attach(client)
    else
      local lsp_highlight_grp = api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
      api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.schedule(vim.lsp.buf.document_highlight)
        end,
        group = lsp_highlight_grp,
        buffer = bufnr,
      })
      api.nvim_create_autocmd("CursorMoved", {
        callback = function()
          vim.schedule(vim.lsp.buf.clear_references)
        end,
        group = lsp_highlight_grp,
        buffer = bufnr,
      })
    end
  end
end

function M.setup(client, bufnr)
  M.highlight(client, bufnr)
end

return M
