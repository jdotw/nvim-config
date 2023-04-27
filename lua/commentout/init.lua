require 'comment'.setup {}

vim.keymap.set('n', '//', '<Plug>(comment_toggle_linewise_current)')
vim.keymap.set('x', '//', '<Plug>(comment_toggle_linewise_visual)')
