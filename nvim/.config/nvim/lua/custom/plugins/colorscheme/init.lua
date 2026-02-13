return {
  "olivercederborg/poimandres.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local function apply_poimandres_contrast_overrides()
      local fg_dark = "#1B1E28"
      vim.api.nvim_set_hl(0, "LspReferenceText", { fg = fg_dark, bg = "#ADD7FF", bold = true })
      vim.api.nvim_set_hl(0, "LspReferenceRead", { fg = fg_dark, bg = "#ADD7FF", bold = true })
      vim.api.nvim_set_hl(0, "LspReferenceWrite", { fg = fg_dark, bg = "#ADD7FF", bold = true })
      vim.api.nvim_set_hl(0, "Search", { fg = fg_dark, bg = "#89DDFF", bold = true })
      vim.api.nvim_set_hl(0, "CurSearch", { fg = fg_dark, bg = "#5DE4C7", bold = true })
    end

    require("poimandres").setup {
      -- leave this setup function empty for default config
      -- or refer to the configuration section
      -- for configuration options
    }

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "poimandres",
      callback = apply_poimandres_contrast_overrides,
    })

    if vim.g.colors_name == "poimandres" then
      apply_poimandres_contrast_overrides()
    end
  end,
}
