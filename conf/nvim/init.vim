" vim: foldmethod=marker

" Load vim-plug {{{
" Install vim plug if not installed
let data_dir = has('nvim') ? stdpath('config') : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif
" }}}

" VIM standard configuration {{{
syntax on
" We want everything to be utf-8
set encoding=utf-8
" - a: Automatically format paragraphs when typing. This option is off by default.
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
set formatoptions=cronm
" This sets the width of a tab character to 4 spaces.
set tabstop=4
" This sets the number of spaces used when the <Tab> key is pressed in insert mode to 4.
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
" Configure how nonprintable characters should be displayed
set listchars=tab:>-,trail:•
" Highlight the 100th column
set colorcolumn=80
" Set text width
set textwidth=80
" Set signcolumn to be expandable
set signcolumn=auto:2
" Use system clipboard
set clipboard=unnamedplus

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

" These lines define key mappings for moving the cursor vertically more quickly
nmap <S-j> 5j<CR>
vmap <S-j> 5j<CR>
nmap <S-k> 5k<CR>
vmap <S-k> 5k<CR>

" Map r to redo
nmap r :redo<CR>

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
" Do not automatically adjust width of vertical splits
set noequalalways
" Our default format for compiler errors is gcc
compiler gcc
" }}}

" Vim script settings {{{
augroup VimScriptExtras
	au!
	au FileType vim vnoremap <buffer> <C-r> "*y \| <Esc>:@*<CR>
augroup END
" }}}

" Settings: quickfix {{{
nnoremap <C-q> :copen<CR>
augroup QuickFixGroup
	au!
	au FileType qf nnoremap <buffer> n :cnext<CR>
	au FileType qf nnoremap <buffer> p :cprev<CR>
	au FileType qf nnoremap <buffer> <C-i> :cclose<CR>
augroup END
" }}}

au CursorMovedI *.md call ModifyTextWidth() " Use only within *.md files

function! ModifyTextWidth()
    if getline(".")=~'^.*\[.*\](.*)$' " If the line ends with Markdown link - set big value for textwidth
        setlocal textwidth=500
    else
        setlocal textwidth=80 " Otherwise use normal textwidth
    endif
endfunction

" Settings: wildmenu {{{
" This remaps the keys so up and down works in completion menus
"cnoremap <Up> <C-p>
"cnoremap <Down> <C-n>
" }}}

" Settings: highlight unwanted spaces {{{
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
augroup TrailingWhitespace
	autocmd!
	autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()
	autocmd FileType floaterm highlight clear ExtraWhitespace
augroup end
let c_space_errors = 1
" }}}

" Load vim plugins {{{
call plug#begin()
	" Plug 'airblade/vim-gitgutter'
	" Plug 'elpiloto/significant.nvim'
	" Plug '~/.config/nvim/mrtee'
	" Plug 'dhruvasagar/vim-dotoo' " managing to-do lists.
	" Plug 'hrsh7th/nvim-compe' " versatile auto-completion.
	Plug 'dhruvasagar/vim-table-mode'
	Plug 'akinsho/bufferline.nvim', { 'tag': 'v3.7.0' } " plugin for tab line at the top
	Plug 'catppuccin/nvim', { 'as': 'catppuccin' } " a beautiful color scheme
	Plug 'dense-analysis/ale' " linting and fixing code.
	Plug 'habamax/vim-asciidoctor' " editing AsciiDoc files.
	Plug 'inkarkat/vim-AdvancedSorters' " advanced sorting of text.
	Plug 'inkarkat/vim-ingo-library' " a library of useful functions for Vim.
	Plug 'jeetsukumaran/vim-buffergator' " easy switching between buffers.
	Plug 'junegunn/goyo.vim' " Clean interface when you need it
	Plug 'kkvh/vim-docker-tools' " Docker integration
	Plug 'ledger/vim-ledger' " ledger accounting system.
	Plug 'lervag/vimtex' " LaTeX editing.
	Plug 'lewis6991/gitsigns.nvim' " text buffer Git integration.
	Plug 'madox2/vim-ai' " AI-assisted coding.
	Plug 'majutsushi/tagbar' " displaying tags in a sidebar.
	Plug 'mbbill/undotree' " Undo/Redo History Visualizer
	Plug 'morhetz/gruvbox' " Gruvbox: Color Scheme
	Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install --frozen-lockfile'} " text completion endine
	Plug 'neovim/nvim-lspconfig' " Language Server Protocol Config
	Plug 'nvim-orgmode/orgmode' " Note-taking, Task-tracking, Outlining, Scheduling
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Syntax and code analysis
	Plug 'p00f/nvim-ts-rainbow' " Colorful parenthesis
	Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' } " File explorer
	Plug 'puremourning/vimspector' " Debugger integration
	Plug 'ryanoasis/vim-devicons' " Developer font icons
	Plug 'stsewd/sphinx.nvim' " Sphinx integration
	Plug 'tpope/vim-commentary' " Commenting tool
	Plug 'tpope/vim-dispatch' " Asynchronous execution
	Plug 'tpope/vim-fugitive' " Git integration
	Plug 'tpope/vim-speeddating' " Quick date navigation
	Plug 'vim-airline/vim-airline' " Visual status line indicators
	Plug 'vim-airline/vim-airline-themes' " Themes for airline
	Plug 'vim-scripts/DoxygenToolkit.vim' " Doxygen support
	Plug 'vim-scripts/SpellCheck' " Spell checking
	Plug 'vim-scripts/c.vim' " Syntax highlighting and indentation
	Plug 'vimwiki/vimwiki' " Note taking and task management
	Plug 'voldikss/vim-floaterm' " Floating terminal support
	Plug 'pangloss/vim-javascript'    " JavaScript support
	Plug 'leafgarland/typescript-vim' " TypeScript syntax
	Plug 'MaxMEllon/vim-jsx-pretty'   " JS and JSX syntax
	Plug 'jparise/vim-graphql'        " GraphQL syntax
call plug#end()
" }}}

" Update all plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	\| :PlugInstall --sync
\| endif

" Plugin: catppuccin/nvim {{{
colorscheme catppuccin
set background=dark " Optional: change to 'light' for the light version
" }}}

" Plugin: lewis6991/gitsigns.nvim {{{
if has_key(plugs, 'gitsigns.nvim')
	lua << EOF
		require("gitsigns").setup{
			signs = {
				add          = { text = '│' },
				change       = { text = '│' },
				delete       = { text = '_' },
				topdelete    = { text = '‾' },
				changedelete = { text = '~' },
				untracked    = { text = '┆' },
			},
			attach_to_untracked = true,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
		}
EOF
	" Popup what's changed in a hunk under cursor
	nnoremap <Leader>gp :Gitsigns preview_hunk<CR>
	" Stage/reset individual hunks under cursor in a file
	nnoremap <Leader>gs	:Gitsigns stage_hunk<CR>
	nnoremap <Leader>gr :Gitsigns reset_hunk<CR>
	nnoremap <Leader>gu :Gitsigns undo_stage_hunk<CR>

	" Stage/reset all hunks in a file
	nnoremap <Leader>gS :Gitsigns stage_buffer<CR>
	nnoremap <Leader>gU :Gitsigns reset_buffer_index<CR>
	nnoremap <Leader>gR :Gitsigns reset_buffer<CR>

	" Git blame
	nnoremap <Leader>gB :Gitsigns toggle_current_line_blame<CR>
endif
" }}}

" Plugin: madox2/vim-ai {{{
let g:vim_ai_chat = {
\	"options": {
\		"model": "gpt-3.5-turbo",
\		"max_tokens": 1000,
\		"temperature": 0.6,
\		"request_timeout": 20,
\		"initial_prompt": "",
\	},
\	"ui": {
\		"code_syntax_enabled": 1,
\		"populate_options": 0,
\		"open_chat_command": "below new | call vim_ai#MakeScratchWindow()",
\		"scratch_buffer_keep_open": 0,
\	},
\}

let g:vim_ai_complete = {
\  "engine": "complete",
\  "options": {
\    "model": "text-davinci-003",
\    "max_tokens": 1000,
\    "temperature": 0.1,
\    "request_timeout": 20,
\    "selection_boundary": "#####",
\  },
\}

let g:vim_ai_edit = {
\  "engine": "complete",
\  "options": {
\    "model": "text-davinci-003",
\    "max_tokens": 4000,
\    "temperature": 0.05,
\    "request_timeout": 20,
\    "selection_boundary": "#####",
\  },
\}

" complete text on the current line or in visual selection
nnoremap <leader>aa :AI<CR>
xnoremap <leader>aa :AI<CR>

" edit text with a custom prompt
xnoremap <leader>as :AIEdit fix grammar and spelling<CR>
nnoremap <leader>as :AIEdit fix grammar and spelling<CR>

" trigger chat
xnoremap <leader>ac :AIChat<CR>
nnoremap <leader>ac :AIChat<CR>

" redo last AI command
nnoremap <leader>a. :AIRedo<CR>
" }}}

" Plugin: airblade/vim-gitgutter {{{
if has_key(plugs, 'vim-gitgutter')
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
endif
" }}}

" Plugin: lervag/vimtex {{{
let g:tex_flavor = 'latex'
" }}}

" Plugin: majutsushi/tagbar {{{
nmap <F8> :TagbarToggle<CR>

" Add support for reStructuredText files in tagbar.
let g:tagbar_type_rst = {
	\ 'ctagstype': 'rst',
	\ 'ctagsbin' : '/home/martin/.local/bin/rst2ctags',
	\ 'ctagsargs' : '-f - --sort=yes --sro=»',
	\ 'kinds' : [
		\ 's:sections',
		\ 'i:images'
	\ ],
	\ 'sro' : '»',
	\ 'kind2scope' : {
		\ 's' : 'section',
	\ },
	\ 'sort': 0,
\ }
" }}}

" Plugin: mbbill/undotree {{{
nmap <F5> :UndotreeToggle<CR>
" }}}

" Plugin: tpope/vim-speeddating {{{
" Remap these because C-A is a tmux escape sequence
let g:speeddating_no_mappings = 1
nmap <C-u> <Plug>SpeedDatingUp
nmap <C-d> <Plug>SpeedDatingDown
xmap <C-u> <Plug>SpeedDatingUp
xmap <C-d> <Plug>SpeedDatingDown
nmap <leader>sdu <Plug>SpeedDatingNowUTC
nmap <leader>sdi <Plug>SpeedDatingNowLocal
" }}}

" Plugin: vimwiki/vimwiki {{{
" Set Vimwiki settings
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
" }}}

" Plugin: dense-analysis/ale {{{
if has_key(plugs, 'ale')
	" Ignore git commit when linting (highly annoying)
	let g:ale_pattern_options = {
	\		'COMMIT_EDITMSG$': {'ale_linters': [], 'ale_fixers': []}
	\	}
	let g:ale_linters = {
	\	'yaml': ['yamllint'],
	\	'cpp': ['clangtidy'],
	\	'c': ['clangtidy'],
	\	'asciidoc': ['cspell'],
	\	'markdown': ['cspell']
	\	}
	let g:ale_linter_aliases = {
	\	'asciidoctor': 'asciidoc'
	\}
	let g:ale_fixers = {
	\	'cpp': ['clang-format'],
	\	'c': ['clang-format']}
	let g:ale_linters_explicit = 0
	let g:ale_completion_enabled = 1
	let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
	let g:ale_set_balloons=1
	let g:ale_hover_to_floating_preview=1
	let g:ale_use_global_executables = 1
	let g:ale_sign_column_always = 1
	let g:ale_disable_lsp = 1

	" Cspell options
	let g:ale_cspell_use_global = 1
	let g:ale_cspell_options = '-c cspell.json'

	" Clang Tidy configuration
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

	" Diagnostics
	let g:ale_use_neovim_diagnostics_api = 1
	let g:airline#extensions#ale#enabled = 1
	" let g:ale_sign_error = '>>'
	" let g:ale_sign_warning = '!!'
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

" Plugin: habamax/vim-asciidoctor {{{
if has_key(plugs, 'vim-asciidoctor')
	let g:asciidoctor_folding = 1
	let g:asciidoctor_fold_options = 1
	let g:asciidoctor_fenced_languages = ['lua', 'vim', 'sh', 'python', 'c', 'javascript']
endif
" }}}

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

" Plugin: jeetsukumaran/vim-buffergator {{{
nmap <silent> <leader>bb :BuffergatorOpen<CR>
nmap <silent> <leader>bB :BuffergatorOpenInTab<CR>
" }}}

" Plugin: lervag/vimtex: Latex editing {{{
let g:tex_flavor = 'latex'
" }}}

" Plugin: majutsushi/tagbar {{{
nmap <F8> :TagbarToggle<CR>
" }}}

" Plugin: mbbill/undotree {{{
nmap <F5> :UndotreeToggle<CR>
" }}}

" Plugin: ledger/vim-ledger: accounting {{{
autocmd BufRead,BufNewFile *.ledger,*.ldg set filetype=ledger
autocmd FileType ledger setlocal includeexpr=substitute(v:fname,'^.*[\\/]\zs','','')
" }}}

" Plugin: tpope/vim-fugitive {{{
" Open git status in interative window (similar to lazygit)
nnoremap <Leader>gg :Git<CR>

" Show `git status output`
nnoremap <Leader>gi :Git status<CR>

" Open commit window (creates commit after writing and saving commit msg)
nnoremap <Leader>gc :Git commit<CR>

" See who committed a particular line of code
nnoremap <Leader>gb :Git blame<CR>

" Other tools from fugitive
nnoremap <Leader>gd :Git difftool<CR>
nnoremap <Leader>gm :Git mergetool<CR>
nnoremap <Leader>gdv :Gvdiffsplit<CR>
nnoremap <Leader>gdh :Gdiffsplit<CR>
" }}}

" Plugin: neoclide/coc.nvim: autocompletion {{{
if has_key(plugs, 'coc.nvim')
	let g:coc_global_extensions = ['coc-clangd', 'coc-tsserver']
	let g:clangd_install_prefix = '/usr/'
	let g:clangd_command = ['clangd',
	\	'--clang-tidy',
	\	'--background-index',
	\	'--header-insertion-decorators=0',
	\	'--completion-style=detailed']

	nnoremap <silent> H :call <sid>show_documentation()<cr>
	function! s:show_documentation()
		if index(['vim', 'help'], &filetype) >= 0
			execute 'help ' . expand('<cword>')
		elseif &filetype ==# 'tex'
			VimtexDocPackage
		else
			call CocAction('doHover')
		endif
	endfunction
	" Use <c-space> to trigger completion
	if has('nvim')
		inoremap <silent><expr> <c-space> coc#refresh()
	else
		inoremap <silent><expr> <c-@> coc#refresh()
	endif
	" Use tab for trigger completion with characters ahead and navigate
	" NOTE: There's always complete item selected by default, you may want to enable
	" no select by `"suggest.noselect": true` in your configuration file
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config
	inoremap <silent><expr> <TAB>
		\ coc#pum#visible() ? coc#pum#next(1) :
		\ CheckBackspace() ? "\<Tab>" :
		\ coc#refresh()
	inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
	function! CheckBackspace() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction
	" Applying code actions to the selected code block
	" Example: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)

	" Remap keys for applying code actions at the cursor position
	nmap <leader>ac  <Plug>(coc-codeaction-cursor)
	" Remap keys for apply code actions affect whole buffer
	nmap <leader>as  <Plug>(coc-codeaction-source)
	" Apply the most preferred quickfix action to fix diagnostic on the current line
	nmap <leader>qf  <Plug>(coc-fix-current)

	" Remap keys for applying refactor code actions
	nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
	xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
	nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

	" Run the Code Lens action on the current line
	nmap <leader>cl  <Plug>(coc-codelens-action)

	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" Map function and class text objects
	" NOTE: Requires 'textDocument.documentSymbol' support from the language server
	xmap if <Plug>(coc-funcobj-i)
	omap if <Plug>(coc-funcobj-i)
	xmap af <Plug>(coc-funcobj-a)
	omap af <Plug>(coc-funcobj-a)
	xmap ic <Plug>(coc-classobj-i)
	omap ic <Plug>(coc-classobj-i)
	xmap ac <Plug>(coc-classobj-a)
	omap ac <Plug>(coc-classobj-a)

	" Remap <C-f> and <C-b> to scroll float windows/popups
	if has('nvim-0.4.0') || has('patch-8.2.0750')
	  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
	  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
	  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	endif

	" Use CTRL-S for selections ranges
	" Requires 'textDocument/selectionRange' support of language server
	nmap <silent> <C-s> <Plug>(coc-range-select)
	xmap <silent> <C-s> <Plug>(coc-range-select)

	" Add `:Format` command to format current buffer
	command! -nargs=0 Format :call CocActionAsync('format')

	" Add `:Fold` command to fold current buffer
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)

	" Add `:OR` command for organize imports of the current buffer
	command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

	" Add (Neo)Vim's native statusline support
	" NOTE: Please see `:h coc-status` for integrations with external plugins that
	" provide custom statusline: lightline.vim, vim-airline
	set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

	" Mappings for CoCList
	" Show all diagnostics
	nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
	" Manage extensions
	nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
	" Show commands
	nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
	" Find symbol of current document
	nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
	" Search workspace symbols
	nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
	" Do default action for next item
	nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
	" Do default action for previous item
	nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
	" Resume latest coc list
	nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
endif
" }}}

" Plugin: nvim-treesitter/nvim-treesitter {{{
if has_key(plugs, 'nvim-treesitter')
	lua << EOF
		-- Treesitter configuration
		require('nvim-treesitter.configs').setup {
			-- If TS highlights are not enabled at all, or disabled via `disable` prop,
			-- highlighting will fallback to default Vim syntax highlighting
			highlight = {
				enable = true, -- false will disable the whole extension
				extended_mode = true,
			use_languagetree = true,
			disable = {}, -- list of language that will be disabled
				-- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
				-- Required for spellcheck, some LaTex highlights and
				-- code block highlights that do not have ts grammar
				additional_vim_regex_highlighting = {'org'},
			},
			rainbow = {
				enable = true,
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
				colors = {}, -- table of hex strings
				termcolors = {} -- table of colour name strings
			},
			ensure_installed = {'org', 'c'},
		}
EOF
endif
" }}}

" Plugin: preservim/nerdtree {{{
autocmd FileType nerdtree setlocal nolist
let g:NERDTreeWinSize = 40
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.o$', '\.obj$', '\.a$', '\.so$', '\.out$', '\.git$']
let NERDTreeShowHidden = 1
let g:NERDTreeGitStatusIndicatorMapCustom = {
\ 'Modified'  :'✹',
\ 'Staged'    :'✚',
\ 'Untracked' :'✭',
\ 'Renamed'   :'➜',
\ 'Unmerged'  :'═',
\ 'Deleted'   :'✖',
\ 'Dirty'     :'✗',
\ 'Ignored'   :'☒',
\ 'Clean'     :'✔︎',
\ 'Unknown'   :'?',
\ }
" }}}

" Plugin: nvim-orgmode/orgmode {{{
if has_key(plugs, 'orgmode')
	lua << EOF
	require('orgmode').setup_ts_grammar()
	require('orgmode').setup({
		org_agenda_files = {'~/board.org'},
		org_default_notes_file = '~/refile.org',
	})
EOF
endif
" }}}

" Plugin: neovim/nvim-lspconfig: language server configs {{{
lua << EOF
local lspconfig = require'lspconfig'
lspconfig.vimls.setup {}
lspconfig.dockerls.setup {}
lspconfig.pyright.setup {}
lspconfig.tailwindcss.setup{}
lspconfig.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" }
}
lspconfig.robotframework_ls.setup({})
lspconfig.clangd.setup{
	on_attach = function(client, bufnr)
		require'completion'.on_attach(client, bufnr)
	end,
	flags = {
		debounce_text_changes = 150,
	},
	cmd = { "clangd", "--background-index" },
	filetypes = { "c", "cpp" },
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, opts)
		vim.keymap.set('i', '<leader>K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})

-- Diagnostics for LSP
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,
		signs = false,
		underline = false,
		update_in_insert = false,
	}
)
EOF
" }}}

" Plugin: puremourning/vimspector {{{
nnoremap <Leader>dd :call vimspector#Launch()<CR>
nnoremap <Leader>dx :call vimspector#Reset()<CR>
nnoremap <Leader>db :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>
nnoremap <Leader>ds :call vimspector#StepInto()<CR>
nnoremap <Leader>dn :call vimspector#StepOver()<CR>
nnoremap <Leader>df :call vimspector#StepOut()<CR>
" }}}

" Plugin: voldikss/vim {{{
nnoremap <C-t> :FloatermToggle!<CR>
augroup FloattermMapping
	autocmd!
	autocmd FileType floaterm nnoremap <buffer> <Esc> <C-\><C-n>:FloatermToggle<CR>
	autocmd FileType floaterm inoremap <buffer> <Esc> <C-\><C-n>:FloatermToggle<CR>
augroup end
tnoremap <Esc> <C-\><C-n>:FloatermToggle<CR>
" }}}

" Plugin: vim-airline/vim-airline {{{
let g:airline_powerline_fonts = 1
let g:airline_theme = 'deus'
" Enable wordcount
let g:airline#extensions#wordcount#enabled = 1
" Add notes to filetypes
let g:airline#extensions#wordcount#filetypes = 'notes|help|markdown|rst|org|text|asciidoctor|tex|mail|plaintext|context'
" }}}

" Settings: spelling {{{
command! SpellIgnore :call execute('spell! ' . expand('<cword>'))
nnoremap <Leader>s :call execute('spell! ' . expand('<cword>'))<CR>
" }}}

" Plugin: habamax/vim-asciidoctor {{{
if has_key(plugs, 'vim-asciidoctor')
	let g:asciidoctor_folding = 1
	let g:asciidoctor_fold_options = 1
	let g:asciidoctor_fenced_languages = ['lua', 'vim', 'sh', 'python', 'c', 'javascript']
endif
" }}}

" Settings: clang-format {{{
function! ClangFormat()
	let l:lines = 'lines=' . (line("'>")-line("'<")+1)
	let l:format_command = 'clang-format -style=file -assume-filename=% -'.l:lines
	execute ":'<,'>! ".l:format_command
endfunction

nnoremap <leader>cf :call ClangFormat()<CR>
vnoremap <leader>cf :call ClangFormat()<CR>
" }}}

" Settings: python3 {{{
" Enable Python3 support
let g:python3_host_prog = '/usr/bin/python3'

" Add the directory containing openai_chat.py to the runtime path
set runtimepath+=~/.config/nvim/python/
" }}}

" Plugin: akinsho/bufferline.nvim {{{
if has_key(plugs, 'bufferline.nvim')
	lua << EOF
		require("bufferline").setup{}
EOF
endif
" }}}

lua << EOF
vim.g.editorconfig = true
EOF
