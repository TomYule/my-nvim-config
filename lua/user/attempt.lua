local M = {}

function M.setup()
  require("attempt").setup {
    list_buffers = true,
  }
  require("telescope").load_extension "attempt"
end

return M
