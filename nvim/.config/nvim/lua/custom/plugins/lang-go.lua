local constants = require "custom.constants"
return {
  {
    enabled = not constants.first_install,
    import = "lazyvim.plugins.extras.lang.go",
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
        servers = {
          gopls = {
            settings = {
              gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
      },
    },
  },

  -- undo none-ls changes added by LazyVim
  {
    "nvimtools/none-ls.nvim",
    enabled = false,
  },
}
