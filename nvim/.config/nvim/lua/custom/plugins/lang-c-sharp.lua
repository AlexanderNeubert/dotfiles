return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs" },
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.roslyn = {
        enabled = false,
        mason = false,
      }
    end,
  },
}
