local M = {}

function M.setup()
  require("toggleterm").setup {
    size = 20,
    hide_numbers = true,
    open_mapping = [[<C-\>]],
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 0.7,
    start_in_insert = true,
    persist_size = true,
    direction = "float",
  }
end

return M
