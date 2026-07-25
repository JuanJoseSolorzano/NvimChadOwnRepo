return {
  -- 1. Install copilot.lua
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-f>", -- Accept full suggestion (avoids Tab conflict with NvChad)
          accept_word = "<C-w>",
          accept_line = "<C-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-x>",
        },
      },
      panel = { enabled = false }, -- Disable side panel, use ghost text
      filetypes = {
        markdown = true,
        help = true,
        ["."] = true,
      },
    },
  },
  -- 2. Integrate with NvChad's completion menu (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          -- FIX: Monkeypatch the deprecated client.is_stopped() call
          -- This prevents the vim.deprecated warning in Neovim 0.13+
          local source = require("copilot_cmp.source")
          source.is_available = function(self)
            -- Use colon notation (:) instead of dot (.) for is_stopped
            if self.client:is_stopped() or self.client.name ~= "copilot" then
              return false
            end
            local get_source_client = function()
              if vim.lsp.get_clients == nil then
                return vim.lsp.get_active_clients({
                  bufnr = vim.api.nvim_get_current_buf(),
                  id = self.client.id,
                })
              end
              return vim.lsp.get_clients({
                bufnr = vim.api.nvim_get_current_buf(),
                id = self.client.id,
              })
            end
            return next(get_source_client()) ~= nil
          end

          -- Now setup the plugin normally
          require("copilot_cmp").setup()
        end,
      },
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      -- Add copilot to the sources list
      table.insert(opts.sources, 1, { name = "copilot", group_index = 2 })
    end,
  },
  -- 3. Optional: Add Copilot status icon to lualine (status bar)
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local function copilot_indicator()
        local clients = vim.lsp.get_clients({ name = "copilot" })
        local copilot_active = #clients > 0
        return copilot_active and "󰚩 " or ""
      end
      table.insert(opts.sections.lualine_x, 2, { copilot_indicator })
    end,
  },
}   