local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local sn = ls.snippet_node
local d = ls.dynamic_node
local f = ls.function_node
local p = require("luasnip.extras").partial

---------------------------- Snippets  ------------------------------------------------
local snippets = {
  s({ trig = "ymd", name = "Current date", dscr = "Insert the current date" }, {
    p(os.date, "%Y-%m-%d"),
  }),

  s("choice", { c(1, { t "choice 1", t "choice 2", t "choice 3" }) }),

  s(
    "dt",
    f(function()
      return os.date "%D - %H:%M"
    end)
  ),

  s("yy", p(os.date, "%Y")),

  s("link_url", {
    t '<a href="',
    f(function(_, snip)
      -- TM_SELECTED_TEXT is a table to account for multiline-selections.
      -- In this case only the first line is inserted.
      return snip.env.TM_SELECTED_TEXT[1] or {}
    end, {}),
    t '">',
    i(1),
    t "</a>",
    i(0),
  }),

  s("dn", {
    t "from: ",
    i(1),
    t { "", "to: " },
    d(2, function(args)
      -- the returned snippetNode doesn't need a position; it's inserted
      -- "inside" the dynamicNode.
      return sn(nil, {
        -- jump-indices are local to each snippetNode, so restart at 1.
        i(1, args[1]),
      })
    end, {
      1,
    }),
  }),

  s("mlink", {
    t "[",
    i(1),
    t "](",
    f(function(_, snip)
      return snip.env.TM_SELECTED_TEXT[1] or {}
    end, {}),
    t ")",
    i(0),
  }),
}

return snippets
