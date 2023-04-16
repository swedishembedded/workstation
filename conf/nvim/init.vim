" vim: foldmethod=marker
syntax on

" VIM standard configuration {{{ a: Automatically format paragraphs when typing. This option is off
" by default.
" - c: Automatically break comments using the textwidth value. This option is on by default.
" - l: Do not break lines that are already long when formatting. This option is off by default.
" - m: Automatically break the current line before inserting a new comment line when typing text
"   beyond textwidth. This option is off by default.
" - n: Recognize numbered lists. When hitting <Enter> in insert mode, the next line will have the
"   same or incremented number. This option is on by default.
" - o: Automatically insert the comment leader when hitting 'o' or 'O' in normal mode. This option
"   is on by default.
" - p: Preserve the existing formatting when using the gq command. This option is off by default.
" - q: Allow the use of gq to format comments. This option is on by default.
" - r: Automatically insert the comment leader when hitting <Enter> in insert mode. This option is
"   on by default.
" - t: Automatically wrap text using textwidth when typing. This option is off by default.
" - v: In visual mode, when using the gq command, break lines at a blank character instead of a
"   blank space. This option is off by default.
" - w: Recognize only whitespace when breaking lines with gq. This option is off by default.
set formatoptions+=cronm
" This sets the width of a tab character to 4 spaces.
set tabstop=4
" This sets the number of spaces used when the <Tab> key is pressed in insert
" mode to 4.
set softtabstop=4
" This sets the number of spaces used for each indentation level when using
" the '>' and '<' commands, as well as the autoindent feature.
set shiftwidth=4
" This setting enables automatic indentation, which will copy the indentation
" of the current line when starting a new line.
set autoindent
" This disables the automatic conversion of tabs to spaces when you press the
" <Tab> key.
set noexpandtab
" This enables the use of the mouse in all modes (normal, visual, insert,
" command-line, etc.).
set mouse=a
" This displays line numbers in the left margin.
set number
" This disables the creation of backup files.
set nobackup
" This disables the creation of swap files.
set noswapfile
" Automatically reload files when they change
set autoread
" Enable spell checking
set spell
set spelllang=en
" Highlight the current line
set cursorline
" Show white space characters and tab characters
set list
" Configure how the tab should be displayed
set listchars=tab:>-
" Highlight the 100th column
set colorcolumn=100
" Set text width
set textwidth=100

" This maps the '<' and '>' keys in visual mode to shift the selected text one
" shift width to the left or right and reselect the shifted text.
vnoremap < <gv
vnoremap > >gv

" The next four lines define key mappings for switching between windows using
" Ctrl + hjkl keys
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" The next four lines define key mappings for resizing windows using Alt +
" hjkl keys:
map <a-l> :vertical res -5<CR>
map <a-h> :vertical res +5<CR>
map <a-j> :res -5<CR>
map <a-k> :res +5<CR>

" These lines define key mappings for moving the cursor 10 spaces at a time
" using Shift + arrow keys:
nmap <S-l> 10l<CR>
nmap <S-h> 10h<CR>
nmap <S-j> 10j<CR>
nmap <S-k> 10k<CR>

" Enable folding
set foldenable
" Configure fold method
" - indent (bigger the indent is - larger the fold level; works quite well for many programming
"   languages)
" - syntax (folding is defined in the syntax files)
" - marker (looks for markers in the text; everything within comments foldable block {{{ and }}} is
"   a fold)
" - expr (fold level is calculated for each line by providing a special function)
set foldmethod=marker
" Set the fold level to start with all folds open
set foldlevelstart=99
" Set the fold nesting level (default is 20)
set foldnestmax=10
" Automatically close folds when the cursor leaves them
set foldclose=
" Open folds upon all motion events
set foldopen=

" }}}
" Load vim-plug {{{
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
" }}}
" Load vim plugins {{{
call plug#begin()
	Plug 'airblade/vim-gitgutter'
	Plug 'dense-analysis/ale'
	Plug 'dhruvasagar/vim-dotoo'
	Plug 'habamax/vim-asciidoctor'
	Plug 'hrsh7th/nvim-compe'
	Plug 'inkarkat/vim-AdvancedSorters'
	Plug 'inkarkat/vim-ingo-library'
	Plug 'ledger/vim-ledger'
	Plug 'lervag/vimtex'
	Plug 'majutsushi/tagbar'
	Plug 'mattn/calendar-vim'
	Plug 'mbbill/undotree'
	Plug 'morhetz/gruvbox'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-orgmode/orgmode'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'p00f/nvim-ts-rainbow'
	Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
	Plug 'puremourning/vimspector'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-dispatch'
	Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-speeddating'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'vim-scripts/DoxygenToolkit.vim'
	Plug 'vim-scripts/SpellCheck'
	Plug 'vim-scripts/c.vim'
	Plug 'vimwiki/vimwiki'
	Plug 'voldikss/vim-floaterm'
call plug#end()
" }}}
" Plugin: airblade/vim-gitgutter {{{
let g:gitgutter_enabled = 1
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'
nmap <Leader>gs <Plug>(GitGutterStageHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)
nmap <Leader>gn <Plug>(GitGutterNextHunk)
nmap <Leader>gp <Plug>(GitGutterPrevHunk)
nmap <Leader>gh <Plug>(GitGutterPreviewHunk)
function! GitStatus()
	let [a,m,r] = GitGutterGetHunkSummary()
	return printf('+%d ~%d -%d', a, m, r)
endfunction
set statusline+=%{GitStatus()}
" }}}
" Latex editing {{{
let g:tex_flavor = 'latex'
" }}}
" Plugin: majutsushi/tagbar {{{
nmap <F8> :TagbarToggle<CR>
" }}}
" Plugin: mbbill/undotree {{{
nmap <F5> :UndotreeToggle<CR>
" }}}

" Ledger
autocmd BufRead,BufNewFile *.ledger,*.ldg set filetype=ledger
autocmd FileType ledger setlocal includeexpr=substitute(v:fname,'^.*[\\/]\zs','','')

" Speeddating
let g:speeddating_no_mappings = 1
nmap <C-u> <Plug>SpeedDatingUp
nmap <C-d> <Plug>SpeedDatingDown

" Plugin: tpope/vim-fugitive {{{
nnoremap <Leader>gb :Gblame<CR>
" }}}

" Set Vimwiki settings
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" Set the color scheme
colorscheme gruvbox
set background=dark " Optional: change to 'light' for the light version

" Configure coc.nvim for autocompletion
let g:coc_global_extensions = ['coc-clangd']
let g:clangd_install_prefix = '/usr/'
let g:clangd_command = ['clangd',
\	'--clang-tidy',
\	'--background-index',
\	'--header-insertion-decorators=0',
\	'--completion-style=detailed']

" Plugin: dense-analysis/ale {{{
if has_key(plugs, 'ale')
	" Ignore git commit when linting (highly annoying)
	let g:ale_pattern_options = {
	\		'COMMIT_EDITMSG$': {'ale_linters': [], 'ale_fixers': []}
	\	}
	let g:ale_linters = {
	\	'yaml': ['yamllint'],
	\	'cpp': ['clangtidy'],
	\	'c': ['clangtidy']
	\	}
	let g:ale_fixers = {
	\	'cpp': ['clang-format'],
	\	'c': ['clang-format']}
	let g:ale_linters_explicit = 0
	let g:ale_completion_enabled = 1
	let g:ale_cpp_clangtidy_options = '-checks=-*,cppcoreguidelines-*'
	let g:ale_cpp_clangtidy_checks = ['readability-*,performance-*,bugprone-*,misc-*']
	let g:ale_cpp_clangtidy_checks += ['clang-analyzer-cplusplus-doc-comments']

	let g:ale_c_clangtidy_options = '-checks=-*,cppcoreguidelines-*'
	let g:ale_c_clangtidy_checks = ['readability-*,performance-*,bugprone-*,misc-*']
	let g:ale_c_clangtidy_checks += ['-readability-function-cognitive-complexity']
	let g:ale_c_clangtidy_checks += ['-readability-identifier-length']
	let g:ale_c_clangtidy_checks += ['-misc-redundant-expression']
	let g:ale_c_build_dir_names = ['build', 'release', 'debug']
	let g:ale_set_balloons=1
	let g:ale_hover_to_floating_preview=1

	" Automatic fixing
	autocmd FileType c nnoremap <leader>f <Plug>(ale_fix)

	" This function searches for the first clang-tidy config in parent directories and sets it
	function! SetClangTidyConfig()
		let l:config_file = findfile('.clang-tidy', expand('%:p:h').';')
		if !empty(l:config_file)
			let g:ale_c_clangtidy_options = '--config=' . l:config_file
			let g:ale_cpp_clangtidy_options = '--config=' . l:config_file
		endif
	endfunction

	" Run this for c and c++ files
	autocmd BufRead,BufNewFile *.c,*.cpp,*.h,*.hpp call SetClangTidyConfig()

	let g:ale_sign_error = '>>'
	let g:ale_sign_warning = '!!'
endif
" }}}
" Plugin: dhruvasagar/vim-dotoo {{{
if has_key(plugs, 'vim-dotoo')
	let g:dotoo#agenda#files = ['~/vimwiki/*.dotoo']
	au BufRead,BufNewFile *.dotoo set filetype=dotoo
endif
" }}}

" Plugin: nvim-orgmode/orgmode {{{
if has_key(plugs, 'orgmode')
	lua << EOF
	-- Load custom treesitter grammar for org filetype
	require('orgmode').setup_ts_grammar()

	-- Treesitter configuration
	require('nvim-treesitter.configs').setup {
	  -- If TS highlights are not enabled at all, or disabled via `disable` prop,
	  -- highlighting will fallback to default Vim syntax highlighting
	  highlight = {
		enable = true,
		-- Required for spellcheck, some LaTex highlights and
		-- code block highlights that do not have ts grammar
		additional_vim_regex_highlighting = {'org'},
	  },
	  ensure_installed = {'org'}, -- Or run :TSUpdate org
	}
	require('orgmode').setup({
	  org_agenda_files = {'~/board.org'},
	  org_default_notes_file = '~/refile.org',
	})
EOF
endif
" }}}

" Setup lsp
" Enable the C language server (clangd)
lua << EOF
local nvim_lsp = require'lspconfig'
nvim_lsp.clangd.setup{
	on_attach = function(client, bufnr)
		require'completion'.on_attach(client, bufnr)
	end,
	flags = {
		debounce_text_changes = 150,
	},
	cmd = { "clangd", "--background-index" },
	filetypes = { "c", "cpp" },
}
nvim_lsp.robotframework_ls.setup({})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = true,
		signs = true,
		update_in_insert = false,
	}
)
EOF

" Make sure we can popup the hover using <leader>s
nnoremap <leader>h :call v:lua.vim.lsp.buf.hover()<CR>
inoremap <leader>h :call v:lua.vim.lsp.buf.hover()<CR>

" Plugin: hrsh7th/nvim-compe {{{
if has_key(plugs, 'nvim-compe')
	set completeopt=menuone,noselect
	let g:compe = {}
	" Enable or disable the nvim-compe plugin
	let g:compe.enabled = v:true
	" Enable or disable automatic completion popup when typing. 
	let g:compe.autocomplete = v:true
	" Enable or disable debug messages. 
	let g:compe.debug = v:false
	" Minimum number of characters that must be entered before completion suggestions are shown.
	let g:compe.min_length = 1
	" Preselect behavior for completion items. 
	let g:compe.preselect = 'enable'
	" Throttle time (in milliseconds) for completion requests to avoid overwhelming the system.
	let g:compe.throttle_time = 80
	" Timeout (in milliseconds) for each completion source.
	let g:compe.source_timeout = 200
	" Timeout (in milliseconds) for resolving completion items.
	let g:compe.resolve_timeout = 800
	" Delay (in milliseconds) for showing completion items when the completion is incomplete.
	let g:compe.incomplete_delay = 400
	" Maximum width of abbreviation in the completion menu.
	let g:compe.max_abbr_width = 100
	" Maximum width of kind (type) in the completion menu.
	let g:compe.max_kind_width = 100
	" Maximum width of the entire completion menu.
	let g:compe.max_menu_width = 100
	" Enable or disable documentation preview for completion items.
	let g:compe.documentation = v:true
	" Enable individual completion sources
	let g:compe.source = {}
	let g:compe.source.buffer = v:true
	let g:compe.source.calc = v:true
	let g:compe.source.emoji = v:true
	let g:compe.source.luasnip = v:true
	let g:compe.source.nvim_lsp = v:true
	let g:compe.source.nvim_lua = v:true
	let g:compe.source.path = v:true
	let g:compe.source.spell = v:true
	let g:compe.source.tags = v:true
	let g:compe.source.treesitter = v:true
	let g:compe.source.ultisnips = v:true
	let g:compe.source.vsnip = v:false

	inoremap <silent><expr> <C-Space> compe#complete()
	inoremap <silent><expr> <CR>      compe#confirm('<CR>')
	inoremap <silent><expr> <C-e>     compe#close('<C-e>')
	inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
	inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
endif
" }}}
" Configure nvim-treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = "c", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	highlight = {
		enable = true, -- false will disable the whole extension
		use_languagetree = true,
		disable = {}, -- list of language that will be disabled
	},
	rainbow = {
		enable = true,
		extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
		colors = {}, -- table of hex strings
		termcolors = {} -- table of colour name strings
	},
}
EOF

" highlight unwanted spaces {{{
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
let c_space_errors = 1
" }}}

" Configure floaterm
nnoremap <C-t> :FloatermToggle<CR>

" Configure NERDTree
let g:NERDTreeWinSize = 40
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.o$', '\.obj$', '\.a$', '\.so$', '\.out$', '\.git$']
let NERDTreeShowHidden = 1

" Configure vim-airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'luna'

" Spelling
command! SpellIgnore :call execute('spell! ' . expand('<cword>'))
nnoremap <Leader>s :call execute('spell! ' . expand('<cword>'))<CR>

" Plugin: habamax/vim-asciidoctor {{{
if has_key(plugs, 'vim-asciidoctor')
	let g:asciidoctor_folding = 1
	let g:asciidoctor_fold_options = 1
	let g:asciidoctor_fenced_languages = ['lua', 'vim', 'sh', 'python', 'c', 'javascript']
endif
" }}}
" Clang format
function! ClangFormat()
	let l:lines = 'lines=' . (line("'>")-line("'<")+1)
	let l:format_command = 'clang-format -style=file -assume-filename=% -'.l:lines
	execute ":'<,'>! ".l:format_command
endfunction

nnoremap <leader>cf :call ClangFormat()<CR>
vnoremap <leader>cf :call ClangFormat()<CR>


