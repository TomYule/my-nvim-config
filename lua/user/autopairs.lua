local M = {}

function M.setup()
  local npairs = require "nvim-autopairs"
  local cmp = require "cmp"
  npairs.setup {
    check_ts = true,
    disable_filetype = { "TelescopePrompt" },
  }

  npairs.add_rules(require "nvim-autopairs.rules.endwise-lua")

  -- Auto pairs
  local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done {})
end

return M
