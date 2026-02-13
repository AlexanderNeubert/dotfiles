local nvim_utils = require "custom.utils.nvim"
local lazy_utils = require "custom.utils.lazy"
local editor_utils = require "custom.utils.editor"
local icons_constants = require "custom.constants.icons"
local constants = require "custom.constants"

return {
  {
    "folke/which-key.nvim",
    -- https://github.com/folke/which-key.nvim/issues/824
    -- version = "v3.14.1",
    event = "VeryLazy",
    init = function()
      vim.opt.timeout = true
    end,
    opts_extend = { "spec", "icons.rules" },
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>m", group = "misc" },
          { "<leader><Tab>", group = "tab" },
          { "<leader>b", group = "buffer" },
          { "<leader>u", group = "ui" },
          { "<leader>f", group = "find/search/replace" },
          { "<leader>g", group = "git" },
          { "<leader>q", group = "quit/session" },
        },
      },
      preset = "helix",
      layout = {
        spacing = 0,
      },
      win = {
        no_overlap = false,
        title = false,
        padding = { 0, 1 },
      },
      icons = {
        rules = {
          -- NOTE: available colors: `azure`, `blue`, `cyan`, `green`, `grey`, `orange`, `purple`, `red`, `yellow`
          { pattern = "paste", icon = " ", color = "azure" },
          { pattern = "avante", icon = icons_constants.lsp_kind.Avante .. " ", color = "blue" },
          { pattern = "comment", icon = " ", color = "grey" },
          { pattern = "zk", icon = " ", color = "green" },
          { pattern = "lsp", icon = " ", color = "red" },
          { pattern = "misc", icon = " ", color = "orange" },
          { pattern = "trouble", icon = "󱖫 ", color = "yellow" },
          { pattern = "snip", icon = icons_constants.lsp_kind.Snippet .. " ", color = "orange" },
          { pattern = "harpoon", icon = "󱡀 ", color = "cyan" },
        },
      },
    },
  },

  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = {
      ignore = {
        filetypes = constants.exclude_filetypes,
      },
      hide = {
        focused_win = true,
        only_win = true,
      },
      window = {
        overlap = {
          borders = true,
        },
        zindex = constants.zindex_float,
        margin = {
          horizontal = 0,
          vertical = 1,
        },
      },
      render = function(props)
        local bufnr = props.buf
        local modified_indicator = " "
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
        local icon, _ = require("nvim-web-devicons").get_icon(filename, nil, {
          default = true,
        })
        if vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
          modified_indicator = "  "
        end
        return { { " " .. icon .. " " }, { filename }, { modified_indicator } }
      end,
    },
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    keys = {
      {
        "<S-l>",
        function()
          local bufferline = require "bufferline"
          pcall(bufferline.cycle, 1)
        end,
        desc = "Next Buffer",
      },
      {
        "<S-h>",
        function()
          local bufferline = require "bufferline"
          pcall(bufferline.cycle, -1)
        end,
        desc = "Prev Buffer",
      },
      {
        "<leader><Tab>d",
        function()
          local ui = require "bufferline.ui"
          vim.cmd "tabclose"
          ui.refresh()
        end,
        desc = "Close",
      },
    },
    init = function()
      -- options already set in options.lua
      -- vim.o.tabline = "%#Normal#"
      -- vim.opt.termguicolors = true

      -- Fix bufferline when restoring a session
      nvim_utils.autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
    opts = {
      options = {
        themable = true,
        numbers = function(_opts)
          return string.format("%s", _opts.raise(_opts.ordinal))
        end,
        close_command = function(n)
          Snacks.bufdelete(n)
        end,
        right_mouse_command = function(n)
          Snacks.bufdelete(n)
        end,
        indicator = {
          style = "none",
        },
        modified_icon = "",
        left_trunc_marker = "❮",
        right_trunc_marker = "❯",
        diagnostics = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        separator_style = { "", "" },
        always_show_bufferline = true,
        hover = { enabled = false },
        offsets = {},
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },

  {
    "folke/noice.nvim",
    event = { "LazyFile", "VeryLazy" },
    keys = {
      { "<leader>n", "", desc = "noice" },

      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>nl",
        function()
          require("noice").cmd "last"
        end,
        desc = "Last Message",
      },
      {
        "<leader>nh",
        function()
          require("noice").cmd "history"
        end,
        desc = "History",
      },
      {
        "<leader>na",
        function()
          require("noice").cmd "all"
        end,
        desc = "History All",
      },
      {
        "<leader>nd",
        function()
          require("noice").cmd "dismiss"
        end,
        desc = "Dismiss All",
      },
      -- scroll signature/hover windows
      {
        "<c-u>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-u>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-d>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-d>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
    },
    opts = {
      -- replace native cmdline
      cmdline = {
        enabled = true,
        format = {
          -- bottom search
          search_down = {
            view = "cmdline",
            icon = "  ",
          },
          search_up = {
            view = "cmdline",
            icon = "  ",
          },
        },
      },
      -- let noice manage messages
      messages = {
        enabled = true,
        -- show search count as virtualtext
        view_search = "virtualtext",
      },
      popupmenu = {
        enabled = false,
      },
      -- show all messages at bottom right
      notify = {
        enabled = true,
        view = "mini",
      },
      lsp = {
        hover = {
          enabled = true,
        },
        signature = {
          -- blink.cmp has signature integration
          enabled = false,
        },
        override = {
          -- better highlighting for lsp signature/hover windows
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              -- yank messages
              { find = "yanked" },
              -- write file messages
              { find = "%d+L, %d+B" },
              -- search messages
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
        },
        -- show long notifications in split
        {
          filter = {
            event = "msg_show",
            min_height = 20,
          },
          view = "cmdline_output",
        },
        -- show cmd output in split
        {
          filter = {
            cmdline = "^:",
          },
          view = "cmdline_output",
        },
      },
      format = {
        level = {
          icons = {
            error = icons_constants.diagnostic.Error,
            warn = icons_constants.diagnostic.Warn,
            info = icons_constants.diagnostic.Info,
          },
        },
      },
      views = {
        -- rice cmdline popup
        cmdline_popup = {
          position = {
            row = 4,
            col = "50%",
          },
          size = {
            min_width = 60,
            width = "auto",
            height = "auto",
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = {
              Normal = "NoiceCmdlinePopupNormal",
              FloatBorder = "NoiceCmdlinePopupBorder",
            },
          },
        },
        -- always enter the split when it opens
        split = {
          enter = true,
        },
        -- fix mini covering statusline
        mini = {
          position = {
            row = -1,
          },
          zindex = constants.zindex_float,
          win_config = {
            winblend = 100,
          },
        },
        -- add padding to lsp doc|signature windows
        -- fix position of lsp doc|signature windows
        hover = {
          size = {
            max_width = 90,
          },
          scrollbar = false,
          border = {
            style = "rounded",
            padding = {
              top = 0,
              bottom = 0,
              left = 0,
              right = 0,
            },
          },
          position = {
            row = 1,
            col = 1,
          },
        },
        -- rice confirm popup
        confirm = {
          align = "top",
          position = {
            row = 4,
            col = "50%",
          },
          border = {
            text = {
              top = "",
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd [[messages clear]]
      end
      require("noice").setup(opts)
    end,
  },

  {
    "j-hui/fidget.nvim",
    tag = "v1.6.1",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = constants.transparent_background and 0 or 100,
          zindex = constants.zindex_float,
        },
      },
      integration = {
        ["nvim-tree"] = {
          enable = false,
        },
        ["xcodebuild-nvim"] = {
          enable = false,
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      -- disable noice lsp progress and messages
      lsp = {
        progress = {
          enabled = false,
        },
        message = {
          enabled = false,
        },
      },
    },
  },

  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      -- indent lines
      indent = {
        indent = {
          -- PERF: causes lag when folding a lot of lines
          enabled = true,
          only_scope = false,
          only_current = true,
          hl = "SnacksIndent",
        },
        animate = {
          enabled = false,
        },
        scope = {
          enabled = true,
          only_current = true,
          hl = "SnacksIndentScope",
        },
        chunk = {
          enabled = false,
          hl = "SnacksIndentChunk",
        },
        blank = {
          hl = "SnacksIndentBlank",
        },
        exclude_filetypes = constants.exclude_filetypes,
        filter = function(buf)
          local exclude_filetypes = lazy_utils.opts("snacks.nvim").indent.exclude_filetypes
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
          return vim.g.snacks_indent ~= false
            and vim.b[buf].snacks_indent ~= false
            and vim.bo[buf].buftype == ""
            and not vim.tbl_contains(exclude_filetypes, filetype)
        end,
      },

      scroll = {
        -- enabled = not constants.in_neovide,
        enabled = false,
        animate = {
          duration = {
            step = 15,
            total = 100,
          },
          easing = "outQuad",
        },
        animate_repeat = {
          delay = 100,
          duration = { step = 5, total = 50 },
          easing = "outQuad",
        },
      },

      statuscolumn = {
        enabled = false,
        left = { "sign" },
        right = { "fold", "git" },
      },

      -- better vim.ui.input
      input = {},

      -- better vim.ui.select
      picker = {
        ui_select = true,
      },

      styles = {
        input = {
          row = 3,
          wo = {
            winhighlight = "",
          },
          keys = {
            n_ctrl_c = { "<C-c>", "cancel", mode = "n" },
          },
        },
      },
    },
  },

  {
    "mcauley-penney/visual-whitespace.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      highlight = { link = "VisualWhitespace" },
      space_char = "·",
      tab_char = "󰌒",
      nl_char = "",
      cr_char = "",
      excluded = {
        filetypes = constants.exclude_filetypes,
        buftypes = constants.exclude_buftypes,
      },
    },
  },

  -- PERF: it causes nvim to freeze
  -- when scrolling to code with colors
  {
    "brenoprata10/nvim-highlight-colors",
    event = "VeryLazy",
    opts = {
      render = "virtual",
      virtual_symbol = icons_constants.other.color,
      virtual_symbol_position = "eol",
      enable_named_colors = false,
      enable_tailwind = false,
      custom_colors = {},
      exclude_filetypes = { "", "bigfile" },
    },
  },

  {
    "tzachar/highlight-undo.nvim",
    event = "VeryLazy",
    init = function()
      -- Highlight on yank
      nvim_utils.autocmd("TextYankPost", {
        group = nvim_utils.augroup "highlight_yank",
        callback = function()
          vim.highlight.on_yank { higroup = "Highlight", timeout = 100 }
        end,
      })
    end,
    opts = {
      duration = 100,
      hlgroup = "Highlight",
      ignored_filetypes = constants.exclude_filetypes,
    },
  },

  {
    "nvim-mini/mini.icons",
    opts = {
      default = {
        file = { glyph = "󰈤", hl = "MiniIconsRed" },
      },
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["README.md"] = { glyph = "󰍔", hl = "MiniIconsGrey" },
        ["CONTRIBUTING.md"] = { glyph = "󰍔", hl = "MiniIconsGrey" },
        ["robots.txt"] = { glyph = "󰚩", hl = "MiniIconsGrey" },
      },
      extension = {
        lock = { glyph = "󰌾", hl = "MiniIconsGrey" },
        ttf = { glyph = "", hl = "MiniIconsGrey" },
        woff = { glyph = "", hl = "MiniIconsGrey" },
        woff2 = { glyph = "", hl = "MiniIconsGrey" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  {
    "rasulomaroff/reactive.nvim",
    event = "VeryLazy",
    config = function()
      local reactive = require "reactive"
      local ok, C = pcall(require, "poimandres.palette")
      if not ok then
        return reactive.setup()
      end

      local function should_skip_common(bufnr)
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
        return vim.tbl_contains(constants.exclude_filetypes, filetype)
          or vim.tbl_contains(constants.exclude_buftypes, buftype)
          or editor_utils.is_bigfile(bufnr, constants.big_file_mb)
      end

      reactive.add_preset {
        name = "poimandres-reactive",
        skip = {
          winhl = function()
            local bufnr = vim.api.nvim_get_current_buf()
            return constants.transparent_background or should_skip_common(bufnr)
          end,
          hl = function()
            local bufnr = vim.api.nvim_get_current_buf()
            return should_skip_common(bufnr)
          end,
        },
        modes = {
          n = {
            winhl = {
              CursorLine = { bg = C.background1 },
            },
            hl = {
              Cursor = { fg = C.background2, bg = C.blue2 },
            },
          },
          i = {
            winhl = {
              CursorLine = { bg = C.teal3 },
            },
            hl = {
              Cursor = { fg = C.background2, bg = C.teal1 },
            },
          },
          [{ "v", "V", "\x16" }] = {
            winhl = {
              CursorLine = { bg = C.blueGray3 },
            },
            hl = {
              Cursor = { fg = C.background2, bg = C.yellow },
            },
          },
          R = {
            winhl = {
              CursorLine = { bg = C.pink3 },
            },
            hl = {
              Cursor = { fg = C.background2, bg = C.pink2 },
            },
          },
        },
        static = {
          winhl = {
            active = {
              CursorLine = { bg = C.background1 },
            },
            inactive = {
              CursorLine = { bg = C.background3 },
            },
          },
        },
      }
      reactive.setup()
    end,
  },
}
