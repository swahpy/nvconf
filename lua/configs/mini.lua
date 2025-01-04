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
    -- snake_case, camelCase, PascalCase, etc; all capitalizations
    w = {
      -- Lua 5.1 character classes and the undocumented frontier pattern:
      -- https://www.lua.org/manual/5.1/manual.html#5.4.1
      -- http://lua-users.org/wiki/FrontierPattern
      -- note: when I say "letter" I technically mean "letter or digit"
      {
        -- Matches a single uppercase letter followed by 1+ lowercase letters.
        -- This covers:
        -- - PascalCaseWords (or the latter part of camelCaseWords)
        "%u[%l%d]+%f[^%l%d]", -- An uppercase letter, 1+ lowercase letters, to end of lowercase letters
        -- Matches lowercase letters up until not lowercase letter.
        -- This covers:
        -- - start of camelCaseWords (just the `camel`)
        -- - snake_case_words in lowercase
        -- - regular lowercase words
        "%f[^%s%p][%l%d]+%f[^%l%d]", -- after whitespace/punctuation, 1+ lowercase letters, to end of lowercase letters
        "^[%l%d]+%f[^%l%d]", -- after beginning of line, 1+ lowercase letters, to end of lowercase letters
        -- Matches uppercase or lowercase letters up until not letters.
        -- This covers:
        -- - SNAKE_CASE_WORDS in uppercase
        -- - Snake_Case_Words in titlecase
        -- - regular UPPERCASE words
        -- (it must be both uppercase and lowercase otherwise it will
        -- match just the first letter of PascalCaseWords)
        "%f[^%s%p][%a%d]+%f[^%a%d]", -- after whitespace/punctuation, 1+ letters, to end of letters
        "^[%a%d]+%f[^%a%d]", -- after beginning of line, 1+ letters, to end of letters
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

require("mini.basics").setup {
  -- Options. Set to `false` to disable.
  options = {
    -- Extra UI features ('winblend', 'cmdheight=0', ...)
    extra_ui = true,

    -- Presets for window borders ('single', 'double', ...)
    win_borders = "single",
  },

  -- Mappings. Set to `false` to disable.
  mappings = {
    -- Window navigation with <C-hjkl>, resize with <C-arrow>
    windows = true,

    -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
    move_with_alt = true,
  },
}

local hipatterns = require "mini.hipatterns"
hipatterns.setup {
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
}

require("mini.move").setup()

local session = require "mini.sessions"
session.setup {
  -- Whether to print session path after action
  verbose = { read = true },
}
local map = vim.keymap.set
map("n", "<leader>ps", function()
  session.select()
end, { desc = "Pick a session" })
map("n", "<leader>sd", function()
  local sessions = {}
  local keystr = ""
  local n = 0
  for k, _ in pairs(session.detected) do
    n = n + 1
    sessions[n] = k
    keystr = keystr .. n .. ": " .. k .. "\n"
  end
  local numstr =
    vim.fn.input("Below are current sessions, please select the one to delete(1/2/...):\n" .. keystr .. "\n> ")
  if numstr == "" then
    return
  end
  local num = tonumber(numstr)
  if num <= n then
    session.delete(sessions[num])
  else
    print "Wrong session number!"
  end
end, { desc = "Delete a session" })

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

local trim = require "mini.trailspace"
trim.setup {}
map("n", "<leader>ts", function()
  trim.trim()
end, { desc = "Trim all trailing whitespaces" })
map("n", "<leader>tl", function()
  trim.trim_last_lines()
end, { desc = "Trim all trailing empty lines" })
