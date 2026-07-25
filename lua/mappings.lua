require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- fix the issue when pressing ctrl+backspace in insert mode the word is not deleted:
map("i", "<C-h>", function()
  local col = vim.fn.col(".")
  if col > 1 then
    local line = vim.fn.getline(".")
    local char_before_cursor = line:sub(col - 1, col - 1)
    if char_before_cursor:match("%s") then
      -- If the character before the cursor is whitespace, delete it
      return "<C-w>"
    else
      -- If it's not whitespace, delete the word before the cursor
      return "<C-w>"
    end
  else
    return ""
  end
end, { expr = true, desc = "Delete word before cursor" })
map("i", "<C-BS>", "<C-w>", { desc = "Delete word before cursor (Ctrl+Backspace)" })

-- Fix issue with Crtl+w in insert mode not deleting the word before the cursor
map("i", "<C-w>", function()
  local col = vim.fn.col(".")
  if col > 1 then
    local line = vim.fn.getline(".")
    local char_before_cursor = line:sub(col - 1, col - 1)
    if char_before_cursor:match("%s") then
      -- If the character before the cursor is whitespace, delete it
      return "<C-w>"
    else
      -- If it's not whitespace, delete the word before the cursor
      return "<C-w>"
    end
  else
    return ""
  end
end, { expr = true, desc = "Delete word before cursor" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>ca", "<Plug>(copilot-accept-panel)", {
  desc = "Copilot Accept Panel Suggestion",
  silent = true
})