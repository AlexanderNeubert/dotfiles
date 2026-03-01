local nvim_utils = require "custom.utils.nvim"
local colors_utils = require "custom.utils.colors"

-- from LazyVim
vim.api.nvim_create_user_command("LazyHealth", function()
  vim.cmd [[Lazy! load all]]
  vim.cmd [[checkhealth]]
end, { desc = "Load all plugins and run :checkhealth" })

-- open Nvim LSP in split
vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd(string.format("vsplit %s", vim.lsp.get_log_path()))
end, {
  desc = "Opens the Nvim LSP client log.",
})

vim.api.nvim_create_user_command("DiffClip", function()
  -- Check if there is a visual selection
  local mode = vim.fn.mode()
  local ft = vim.bo.filetype

  if mode == "v" or mode == "V" then
    -- Save the visual selection into the unnamed register
    vim.cmd 'normal! "vy'
  else
    -- Select the entire file if there is no selection
    vim.cmd 'normal! ggVG"vy'
  end

  vim.cmd [[
    tabnew [Selection]
    setlocal bufhidden=wipe buftype=nofile noswapfile
    put v
    0d_
    " Remove Windows CR
    silent %s/\r$//e
  ]]
  vim.bo.filetype = ft

  -- Open a new vertical split to display clipboard content
  vim.cmd [[
    vnew [Clipboard]
    setlocal bufhidden=wipe buftype=nofile noswapfile
    put +
    0d_
    " Remove Windows CR
    silent %s/\r$//e
  ]]
  vim.bo.filetype = ft

  -- Enable diff mode in both buffers
  vim.cmd "diffthis"
  vim.opt_local.winhl = table.concat({
    "DiffDelete:DiffviewDiffDeleteSign",
    "DiffChange:GitSignsAddPreview",
    "DiffText:GitSignsAddInline",
  }, ",")
  vim.cmd "wincmd p"
  vim.cmd "diffthis"
  vim.opt_local.winhl = table.concat({
    "DiffAdd:GitSignsDeletePreview",
    "DiffDelete:DiffviewDiffDeleteSign",
    "DiffChange:GitSignsDeletePreview",
    "DiffText:GitSignsDeleteInline",
  }, ",")
end, { desc = "Compare Selection or Active File with Clipboard", range = false })

-- toggles between rgb and hex
vim.api.nvim_create_user_command("ToggleColorFormat", function()
  local selected_text = nvim_utils.get_visual_selection()
  if not selected_text then
    return
  end

  if selected_text:match "^#?%x%x%x%x%x%x$" then
    local rgb = colors_utils.hex_to_rgb(selected_text)
    nvim_utils.replace_visual_selection(rgb)
  end

  if selected_text:match "^rgb%(%d+,%s*%d+,%s*%d+%)$" then
    local hex = colors_utils.rgb_to_hex(selected_text)
    nvim_utils.replace_visual_selection(hex)
  end
end, { desc = "Toggle Color Format", range = true })
