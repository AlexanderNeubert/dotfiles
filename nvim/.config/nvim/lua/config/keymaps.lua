-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Telescope keymaps
-- vim.keymap.set("n", "<space>fp", function()
--   require("telescope.builtin").find_files({
--     cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
--   })
-- end, { desc = "Find Files (Lazy-files)" })
--
-- vim.keymap.set("n", "<space>fh", require("telescope.builtin").help_tags, { desc = "Find Files (Help Tags)" })

-- Remove the default scratch keymaps
vim.keymap.del("n", "<leader>.")
vim.keymap.del("n", "<leader>S")
