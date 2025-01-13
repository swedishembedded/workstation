" Apply settings only for JavaScript and TypeScript files
autocmd FileType javascript,javascriptreact,typescript,typescriptreact call SetJSandTSSettings()

" Define a function for JS/TS-specific settings
function! SetJSandTSSettings()
  " Use spaces instead of tabs
  setlocal expandtab
  " Set the number of spaces per tab
  setlocal shiftwidth=2
  setlocal tabstop=2
  setlocal softtabstop=2
  " Enable auto-indentation
  setlocal autoindent
  setlocal smartindent
  " Disable automatic insertion of matching parentheses and quotes
  let b:loaded_matchparen = 1
endfunction
