local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node

local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local snippets = {
  s("mytest", {
    fmt(
      [[
      #[test]
      fn {}(){}{{
          {}
      }}
    ]],
      {
        i(1, "testname"),
        c(2, {
          t "",
          t " -> Result<()> ",
        }),
        i(0),
      }
    ),
  }),
}

return snippets
