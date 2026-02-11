return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "c_sharp" },
    },
  },

  {
    "seblyng/roslyn.nvim",
    ft = { "cs" },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = { "roslyn" },
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      local _ = require("mason.settings").current.install_root_dir

      opts.servers = opts.servers or {}
      opts.servers.roslyn = {}
    end,
  },
}
