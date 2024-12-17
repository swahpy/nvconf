require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr><Esc>")
map({ "n", "i", "v" }, "<A-w>", "<cmd> w <cr><Esc>")

-- tabufline keymaps
local tabs = require "nvchad.tabufline"

map("n", "<S-h>", function()
  tabs.prev()
end, { desc = "TAB navigate to previous tab" })
map("n", "<S-l>", function()
  tabs.next()
end, { desc = "TAB navigate to next tab" })
for i = 1, 9, 1 do
  vim.keymap.set("n", string.format("<A-%s>", i), function()
    local len = #vim.t.bufs
    if i <= len then
      vim.api.nvim_set_current_buf(vim.t.bufs[i])
    end
  end)
end
