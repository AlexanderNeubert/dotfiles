local constants = require "custom.constants"
local lazyvim_utils = require "custom.utils.lazyvim"
local nvim_utils = require "custom.utils.nvim"
local window_picker_utils = require "custom.utils-plugins.window-picker"
local lsp_utils = require "custom.utils.lsp"
local smart_splits_utils = require "custom.utils-plugins.smart-splits"

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    keys = {
      {
        "<leader>ql",
        "<cmd>lua require('persistence').load()<CR>",
        desc = "Last Session",
      },
      {
        "<leader>qs",
        "<cmd>lua require('persistence').save()<CR>",
        desc = "Save Session",
      },
    },
    opts = {},
  },

  {
    "nvim-mini/mini.bracketed",
    event = "VeryLazy",
    opts = {
      buffer = { suffix = "" },
      comment = { suffix = "" },
      conflict = { suffix = "" },
      diagnostic = { suffix = "" },
      file = { suffix = "" },
      indent = { suffix = "" },
      jump = { suffix = "j" },
      location = { suffix = "l" },
      oldfile = { suffix = "o" },
      quickfix = { suffix = "q" },
      treesitter = { suffix = "s" },
      undo = { suffix = "" },
      window = { suffix = "" },
      yank = { suffix = "" },
    },
  },

  {
    "kazhala/close-buffers.nvim",
    keys = {
      {
        "<leader>bo",
        function()
          require("close_buffers").delete { type = "hidden" }
        end,
        desc = "Close Others",
      },
      {
        "<leader>bO",
        function()
          require("close_buffers").delete { type = "hidden", force = true }
        end,
        desc = "Close Others!",
      },
    },
    opts = {
      filetype_ignore = constants.exclude_filetypes,
    },
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = {
      {
        "<leader>h",
        "",
        desc = "harpoon",
      },

      {
        "<leader>hs",
        function()
          local harpoon = require "harpoon"
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Quick Menu",
      },
      {
        "<leader>ha",
        "<cmd>lua require('harpoon'):list():add()<CR>",
        desc = "Add",
      },
      {
        "<leader>h1",
        "<cmd>lua require('harpoon'):list():select(1)<CR>",
        desc = "Buffer 1",
      },
      {
        "<leader>h2",
        "<cmd>lua require('harpoon'):list():select(2)<CR>",
        desc = "Buffer 2",
      },
      {
        "<leader>h3",
        "<cmd>lua require('harpoon'):list():select(3)<CR>",
        desc = "Buffer 3",
      },
      {
        "<leader>h4",
        "<cmd>lua require('harpoon'):list():select(4)<CR>",
        desc = "Buffer 4",
      },
      {
        "[H",
        "<cmd>lua require('harpoon'):list():prev()<CR>",
        desc = "Prev Buffer (Harpoon)",
      },
      {
        "]H",
        "<cmd>lua require('harpoon'):list():next()<CR>",
        desc = "Next Buffer (Harpoon)",
      },
    },
    opts = {
      settings = {
        save_on_toggle = true,
      },
    },
  },

  {
    "declancm/maximize.nvim",
    event = "VeryLazy",
    opts = function()
      Snacks.toggle({
        name = "Maximize",
        get = function()
          return vim.t.maximized
        end,
        set = function(enabled)
          local m = require "maximize"
          if enabled then
            m.maximize()
          else
            m.restore()
          end
        end,
      }):map "<leader>um"

      return {
        aerial = { enable = false },
      }
    end,
  },

  {
    "mrjones2014/smart-splits.nvim",
    -- PERF: It can double the startup time in some environments,
    -- e.g., when your laptop is in power-saving mode
    commit = "2b5dda43b3de5d13b56c4606f7d19db78637e527", -- v2.0.3
    keys = {
      -- focus windows
      {
        "<C-Left>",
        "<cmd>lua require('smart-splits').move_cursor_left()<cr>",
        desc = "Focus Window Left",
      },
      {
        "<C-Right>",
        "<cmd>lua require('smart-splits').move_cursor_right()<cr>",
        desc = "Focus Window Right",
      },
      {
        "<C-Down>",
        "<cmd>lua require('smart-splits').move_cursor_down()<cr>",
        desc = "Focus Window Down",
      },
      {
        "<C-Up>",
        "<cmd>lua require('smart-splits').move_cursor_up()<cr>",
        desc = "Focus Window Up",
      },

      -- resize windows
      {
        "<C-S-A-Left>",
        "<cmd>lua require('smart-splits').resize_left()<cr>",
        desc = "Resize Window Left",
      },
      {
        "<C-S-A-Right>",
        "<cmd>lua require('smart-splits').resize_right()<cr>",
        desc = "Resize Window Right",
      },
      {
        "<C-S-A-Down>",
        "<cmd>lua require('smart-splits').resize_down()<cr>",
        desc = "Resize Window Down",
      },
      {
        "<C-S-A-Up>",
        "<cmd>lua require('smart-splits').resize_up()<cr>",
        desc = "Resize Window Up",
      },

      -- swap windows
      {
        "<C-S-Left>",
        "<cmd>lua require('smart-splits').swap_buf_left()<cr>",
        desc = "Swap Buffer Left",
      },
      {
        "<C-S-Right>",
        "<cmd>lua require('smart-splits').swap_buf_right()<cr>",
        desc = "Swap Buffer Right",
      },
      {
        "<C-S-Down>",
        "<cmd>lua require('smart-splits').swap_buf_down()<cr>",
        desc = "Swap Buffer Down",
      },
      {
        "<C-S-Up>",
        "<cmd>lua require('smart-splits').swap_buf_up()<cr>",
        desc = "Swap Buffer Up",
      },
    },
    opts = {
      cursor_follows_swapped_bufs = true,
      at_edge = "stop",
      default_amount = 4,
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)

      -- in tmux, smart-splits sometimes set pane-is-vim to 0
      -- even if we didn't left nvim
      local mux = require("smart-splits.mux").get()
      if not mux or mux.type ~= "tmux" then
        return
      end
      nvim_utils.autocmd("FocusGained", {
        group = nvim_utils.augroup "fix_on_init_smart_splits_nvim",
        callback = function()
          local pane_id = os.getenv "TMUX_PANE"
          if tonumber(smart_splits_utils.tmux_exec { "show-options", "-pqvt", pane_id, "@pane-is-vim" }) == 1 then
            return
          end
          smart_splits_utils.tmux_exec { "set-option", "-pt", pane_id, "@pane-is-vim", 1 }
        end,
      })
    end,
  },

  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      -- termimal
      {
        "<A-i>",
        function()
          local PATH = vim.env.PATH
          if constants.in_nix then
            -- undo overwrite of PATH in lua/custom/globals.lua
            PATH = PATH:gsub("/run/current%-system/sw/bin/:", "", 1)
          end
          Snacks.terminal.toggle("PATH=" .. PATH .. " zsh", {
            win = {
              border = "rounded",
            },
          })
        end,
        desc = "Toggle Terminal",
        mode = { "n", "t" },
      },

      -- bufdelete
      {
        "<leader>w",
        "<leader>bd",
        desc = "Close Buffer",
        remap = true,
      },
      {
        "<leader>W",
        "<leader>bD",
        desc = "Close Buffer!",
        remap = true,
      },
      {
        "<leader>C",
        function()
          Snacks.bufdelete { force = true }
          vim.api.nvim_win_close(0, true)
        end,
        desc = "Close Buffer!",
        remap = true,
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Close",
      },
      {
        "<leader>bD",
        function()
          Snacks.bufdelete { force = true }
        end,
        desc = "Close!",
      },

      -- gitbrowse
      {
        "<leader>go",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
        mode = { "n", "v" },
      },
    },
    opts = {
      styles = {
        terminal = {
          width = constants.width_fullscreen,
          height = constants.height_fullscreen,
          wo = {
            winhighlight = "NormalFloat:Normal,FloatBorder:SnacksTermFloatBorder",
          },
          keys = {
            term_normal = false,
          },
        },
      },
    },
  },

  {
    "CRAG666/betterTerm.nvim",
    keys = {
      {
        mode = { "n", "t" },
        "<A-t>",
        function()
          require("betterTerm").open()
        end,
        desc = "Open BetterTerm 0",
      },
      {
        "<leader>ft",
        function()
          require("betterTerm").select()
        end,
        desc = "Find terminal",
      },
    },
    opts = {
      size = math.floor(vim.o.lines * 0.5),
      new_tab_mapping = "<C-n>",
      jump_tab_mapping = "<C-$tab>",
      active_tab_hl = "TabLineSel",
      inactive_tab_hl = "TabLine",
      new_tab_hl = "BetterTermSymbol",
      new_tab_icon = "+",
      index_base = 1,
    },
  },

  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      Snacks.toggle.zen():map "<leader>uz"

      return vim.tbl_deep_extend("force", opts, {
        zen = {
          toggles = {
            dim = false,
            diagnostics = false,
            -- TODO: it doesn't toggle off git_signs
            git_signs = false,
          },
          show = {
            statusline = false,
          },
          on_open = function(win)
            local bufnr = win.buf
            -- TODO: edge case where if you are in zen mode
            -- and switch to a different buffer
            -- this fn doesn't get called
            lsp_utils.toggle_inlay_hints(bufnr, false)
          end,
          on_close = function(win)
            local bufnr = win.buf
            lsp_utils.toggle_inlay_hints(bufnr, true)
          end,
        },
        styles = {
          zen = {
            zindex = constants.zindex_fullscreen,
            width = constants.width_fullscreen,
            height = 0,
            wo = {
              cursorline = false,
              cursorcolumn = false,
            },
            -- removes cursorline, cursorcolumn, numbers and signs
            minimal = false,
          },
        },
      })
    end,
  },

  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
      Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>uL"
      Snacks.toggle.line_number():map "<leader>ul"
      Snacks.toggle
        .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
        :map "<leader>uc"

      return vim.tbl_deep_extend("force", opts, {
        toggle = {
          map = lazyvim_utils.safe_keymap_set,
          notify = false,
        },
      })
    end,
  },

  {
    "chrishrb/gx.nvim",
    submodules = false,
    cmd = { "Browse" },
    keys = {
      {
        "gl",
        "<Cmd>Browse<CR>",
        mode = { "n", "x" },
      },
    },
    init = function()
      -- disable netrw gx
      vim.g.netrw_nogx = 1
    end,
    opts = {},
  },

  -- library used by other plugins
  { "nvim-lua/plenary.nvim" },
  { "nvim-lua/popup.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "nvim-neotest/nvim-nio" },
}
