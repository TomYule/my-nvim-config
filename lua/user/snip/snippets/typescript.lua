local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node

local snippets = {
  s("todo", t "console.log('TODO')"),
  s("stack", t "serverless stack"),
}

return snippets
