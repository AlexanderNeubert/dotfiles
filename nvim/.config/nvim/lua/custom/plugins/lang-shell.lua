local nvim_utils = require "custom.utils.nvim"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      nvim_utils.autocmd("BufEnter", {
        group = nvim_utils.augroup "disable_diagnostics_in_env_files",
        pattern = ".env*",
        callback = function(event)
          vim.diagnostic.enable(false, {
            bufnr = event.buf,
          })
        end,
      })

      vim.filetype.add {
        pattern = {
          ["%.env%.[%w_.-]+"] = "sh",
        },
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        bashls = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        just = { "just" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
      },
    },
  },
}
