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

      -- MARKDOWN OVERRIDE --
      -- render-markdown: heading foregrounds (H1 brightest → H6 most muted)
      vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = "#5DE4C7", bold = true }) -- teal1
      vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = "#ADD7FF", bold = true }) -- blue2
      vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = "#89DDFF", bold = true }) -- blue1
      vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = "#91B4D5", bold = true }) -- blue3
      vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = "#A6ACCD" })              -- blueGray1
      vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = "#767C9D" })              -- blueGray2

      -- render-markdown: heading backgrounds (subtle gradient, most visible at H1)
      vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#252837" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#222535" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#1F2230" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "#1D202B" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "#1C1F29" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "#1B1E28" }) -- same as bg

      -- render-markdown: code blocks and inline code
      vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#252837" })

      -- render-markdown: links
      vim.api.nvim_set_hl(0, "RenderMarkdownLink", { fg = "#89DDFF", underline = true }) -- blue1

      -- render-markdown: blockquotes
      vim.api.nvim_set_hl(0, "RenderMarkdownQuote", { fg = "#767C9D" }) -- blueGray2

      -- render-markdown: bullets
      vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#5DE4C7" }) -- teal1

      -- render-markdown: horizontal rule
      vim.api.nvim_set_hl(0, "RenderMarkdownDash", { fg = "#303340" }) -- background1

      -- render-markdown: table header
      vim.api.nvim_set_hl(0, "RenderMarkdownTableHead", { fg = "#ADD7FF", bold = true }) -- blue2

      -- render-markdown: checkboxes
      vim.api.nvim_set_hl(0, "RenderMarkdownChecked",   { fg = "#5DE4C7" }) -- teal1
      vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked", { fg = "#767C9D" }) -- blueGray2
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
