---@type Config
return {
  lazy = {
    {
      "keaising/im-select.nvim",
      config = function()
        require("im_select").setup({
          default_im_select   = "com.apple.keylayout.US",
          async_switch_im     = true,
          set_previous_events = { "InsertEnter" },
          set_default_events  = { "InsertLeave", "CmdlineLeave" },
        })
      end,
    },
    {
      "folke/tokyonight.nvim",
      version = false,
      lazy = false,
      priority = 1000, -- make sure to load this before all the other start plugins
      -- Optional; default configuration will be used if setup isn't called.
      config = function()
        require("tokyonight").setup({
          transparent = true
        })
        vim.cmd.colorscheme("tokyonight")
      end,
    },

    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      init = function()
        vim.opt.laststatus = 3
      end,
      opts = {
        options = {
          icons_enabled = true,
          theme = "auto",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { require("junikim.utils").getWords },
        },
      },
    },
  }
}
