local ai = require "mini.ai"
ai.setup {
  -- Number of lines within which textobject is searched
  n_lines = 500,
  custom_textobjects = {
    o = ai.gen_spec.treesitter { -- code block
      a = {
        "@block.outer",
        "@conditional.outer",
        "@loop.outer",
      },
      i = {
        "@block.inner",
        "@conditional.inner",
        "@loop.inner",
      },
    },
    f = ai.gen_spec.treesitter {
      a = "@function.outer",
      i = "@function.inner",
    }, -- function
    c = ai.gen_spec.treesitter {
      a = "@class.outer",
      i = "@class.inner",
    }, -- class
    t = {
      "<([%p%w]-)%f[^<%w][^<>]->.-</%1>",
      "^<.->().*()</[^/]->$",
    }, -- tags
    d = { "%f[%d]%d+" }, -- digits
    e = { -- Word with case
      {
        "%u[%l%d]+%f[^%l%d]",
        "%f[%S][%l%d]+%f[^%l%d]",
        "%f[%P][%l%d]+%f[^%l%d]",
        "^[%l%d]+%f[^%l%d]",
      },
      "^().*()$",
    },
    u = ai.gen_spec.function_call(), -- u for "Usage"
    U = ai.gen_spec.function_call { name_pattern = "[%w_]" }, -- without dot in function name
    h = { "%f[%S][%w%p]+%f[%s]", "^().*()$" }, -- match content between space
    -- j = { "%f[^%c][^%c]*", "^%s*().-()%s*$" }, -- match whole line
    -- from mini.extra
    -- B = gen_ai_spec.buffer(),
    -- D = gen_ai_spec.diagnostic(),
    -- I = gen_ai_spec.indent(),
    -- L = gen_ai_spec.line(),
    -- d = gen_ai_spec.number(),
  },
}

require("mini.splitjoin").setup {
  mappings = {
    toggle = "gS",
    split = "gs",
    join = "gj",
  },
}

require("mini.surround").setup {
  n_lines = 500,
  respect_selection_type = true,
  search_method = "cover_or_next",
}
