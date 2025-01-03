require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr><Esc>")
map({ "n", "i", "v" }, "<A-w>", "<cmd> w <cr><Esc>")

-- move
map({ "n", "i" }, "<C-h>", "<C-w>h", { desc = "switch window left" })
map({ "n", "i" }, "<C-l>", "<C-w>l", { desc = "switch window right" })
map({ "n", "i" }, "<C-j>", "<C-w>j", { desc = "switch window down" })
map({ "n", "i" }, "<C-k>", "<C-w>k", { desc = "switch window up" })
map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "switch window left" })
map("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "switch window right" })
map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "switch window down" })
map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "switch window up" })

map("i", "<A-h>", "<Left>", { desc = "move left" })
map("i", "<A-l>", "<Right>", { desc = "move right" })
map("i", "<A-j>", "<Down>", { desc = "move down" })
map("i", "<A-k>", "<Up>", { desc = "move up" })

-- nvimtree
map({ "n", "t" }, "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map({ "n", "t" }, "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- terminal
map("t", "<C-t>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })
map({ "n", "t" }, "<A-->", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

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
map("n", "<S-tab>", function()
  tabs.move_buf(-1)
end, { desc = "Move buf left" })
map("n", "<Tab>", function()
  tabs.move_buf(1)
end, { desc = "Move buf right" })

-- disable mappings
local nomap = vim.keymap.del

nomap({ "n", "t" }, "<A-h>")
