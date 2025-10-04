return {
  'rmagatti/auto-session',
  lazy = false,
  config = function()
    require("auto-session").setup {
    }
    vim.keymap.set('n', "<C-s>c",  ':AutoSession search<CR>', {
      noremap = true,
      desc = "Change Session"
    })
    vim.keymap.set('n', '<C-s>s', ':AutoSession save<CR>', { desc = "Save Session" })
    vim.keymap.set('n', '<C-s>d', ':AutoSession delete<CR>', { desc = "Delete Session" })
  end
}
