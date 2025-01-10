return {
  filetypes = { "markdown" },
  --- Vim modes where the preview is shown
  ---@type string[]
  modes = { "n", "no", "c" },
  headings = {
    shift_width = 0,
    heading_1 = {
      align = "center",
      icon = "󰲠 ",
      hl = "",
      style = "label",
    },
    heading_2 = {
      icon = "󰲢 ",
      hl = "",
    },
    heading_3 = {
      icon = "󰲤 ",
      hl = "",
    },
    heading_4 = {
      icon = "󰲦 ",
      hl = "",
    },
    heading_5 = {
      icon = "󰲨 ",
      hl = "",
    },
    heading_6 = {
      icon = "󰲪 ",
      hl = "",
    },
  },
  inline_codes = {
    hl = "",
  },
}
