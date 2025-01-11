local mc = require "multicursor-nvim"

mc.setup()

local map = vim.keymap.set

-- Add or skip cursor above/below the main cursor.
map({ "n", "v" }, "<up>", function()
  mc.lineAddCursor(-1)
end)
map({ "n", "v" }, "<down>", function()
  mc.lineAddCursor(1)
end)
map({ "n", "v" }, "<leader><up>", function()
  mc.lineSkipCursor(-1)
end)
map({ "n", "v" }, "<leader><down>", function()
  mc.lineSkipCursor(1)
end)

-- Add or skip adding a new cursor by matching word/selection
map({ "n", "v" }, "<leader>n", function()
  mc.matchAddCursor(1)
end, { desc = "add next match cursor" })
map({ "n", "v" }, "<leader>ss", function()
  mc.matchSkipCursor(1)
end, { desc = "skip match cursor" })
map({ "n", "v" }, "<leader>N", function()
  mc.matchAddCursor(-1)
end, { desc = "add previous match cursor" })
map({ "n", "v" }, "<leader>sS", function()
  mc.matchSkipCursor(-1)
end, { desc = "skip cursor reversely" })

-- Add all matches in the document
map({ "n", "v" }, "<leader>A", mc.matchAllAddCursors, { desc = "add all match cursors" })

-- Delete the main cursor.
map({ "n", "v" }, "<leader>dc", mc.deleteCursor, { desc = "delete cursor" })

-- Add and remove cursors with control + left click.
map("n", "<c-leftmouse>", mc.handleMouse)

-- Easy way to add and remove cursors using the main cursor.
map({ "n", "v" }, "<leader>tc", mc.toggleCursor, { desc = "toggle cursor" })

map("n", "<esc>", function()
  if not mc.cursorsEnabled() then
    mc.enableCursors()
  elseif mc.hasCursors() then
    mc.clearCursors()
  else
    -- Default <esc> handler.
  end
end)

-- bring back cursors if you accidentally clear them
map("n", "<leader>rc", mc.restoreCursors, { desc = "restore cursor" })

-- Align cursor columns.
map("n", "<leader>a", mc.alignCursors, { desc = "align cursors" })

-- Split visual selections by regex.
map("v", "S", mc.splitCursors)

-- Append/insert for each line of visual selections.
map("v", "I", mc.insertVisual)
map("v", "A", mc.appendVisual)

-- match new cursors within visual selections by regex.
map("v", "M", mc.matchCursors)

-- Rotate visual selection contents.
map("v", "<leader>t", function()
  mc.transposeCursors(1)
end)
map("v", "<leader>T", function()
  mc.transposeCursors(-1)
end)

-- Customize how cursors look.
local hl = vim.api.nvim_set_hl
hl(0, "MultiCursorCursor", { link = "Cursor" })
hl(0, "MultiCursorVisual", { link = "Visual" })
hl(0, "MultiCursorSign", { link = "SignColumn" })
hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
