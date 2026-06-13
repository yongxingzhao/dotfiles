return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      render_modes = { "n", "c", "t" },
      heading = { position = "overlay", width = "full", border = true },
      code = { style = "full", width = "block", min_width = 60, border = "thin" },
      pipe_table = { style = "full", cell = "padded" },
    },
    keys = {
      { "<leader>um", "<Cmd>RenderMarkdown toggle<CR>", desc = "Toggle Markdown Render", ft = "markdown" },
    },
  },
}
