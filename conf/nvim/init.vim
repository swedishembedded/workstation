" vim: foldmethod=marker

" ============================================================================
" 1. PLUGIN MANAGER BOOTSTRAP {{{
" ============================================================================
" Install vim-plug if not installed
let data_dir = has('nvim') ? stdpath('config') : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif
" }}}

" ============================================================================
" 2. CORE VIM SETTINGS {{{
" ============================================================================

" Basic settings {{{
syntax on
set encoding=utf-8
set mouse=a
set number
set cursorline
set autoread
set clipboard=unnamedplus
" }}}

" Backup and swap {{{
set nobackup
set noswapfile
" }}}

" Indentation and formatting {{{
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set noexpandtab
set textwidth=80
set formatoptions=cronm
" }}}

" Display settings {{{
set list
set listchars=tab:>-,trail:•
set colorcolumn=80
set signcolumn=auto:2
" }}}

" Spell checking {{{
set spell
set spelllang=en
" }}}

" Folding {{{
set foldenable
set foldmethod=marker
set foldlevelstart=99
set foldnestmax=10
set foldclose=
set foldopen=
" }}}

" Other settings {{{
set noequalalways
compiler gcc
" }}}

" }}}

" ============================================================================
" 3. KEY MAPPINGS (CORE) {{{
" ============================================================================
"
" KEYBINDING REFERENCE AND CONFLICT NOTES:
" =========================================
"
" Navigation & Window Management:
"   <C-h>         - Window left
"   <C-j>         - Window down
"   <C-l>         - Window right
"   <A-Up>        - Window up (changed from <C-k> to avoid LSP conflict)
"   <A-h/j/k/l>   - Window resize
"   <S-h/j/k/l>   - Fast cursor movement (5 chars/lines)
"
" LSP (Language Server Protocol) - Only active in LSP-enabled buffers:
"   <C-k>         - Show hover documentation (CONFLICTS with old window nav)
"   K             - Show hover documentation (Vim standard)
"   gh            - Show hover documentation (alternative)
"   gK            - Show signature help
"   <C-s>         - Show signature help (insert mode)
"   <M-k>         - Show signature help (insert mode, Alt-K)
"   (             - Auto-triggers signature help (insert mode)
"   gd            - Go to definition
"   gD            - Go to declaration
"   gi            - Go to implementation
"   gr            - Find references (opens quickfix)
"   <Space>ca     - Code actions
"   <Space>rn     - Rename symbol
"   <Space>f      - Format buffer
"   <Space>e      - Show diagnostics in float
"   [d            - Previous diagnostic
"   ]d            - Next diagnostic
"   <C-Space>     - Trigger completion (insert mode)
"   <Leader>ih    - Toggle inlay hints (disabled by default, use to enable temporarily)
"   <Esc>         - Close any floating windows (hover, signature help, diagnostics)
"
" File & Buffer Management:
"   <C-n>         - NERDTree toggle
"   <Leader>bb    - Buffergator open
"   <Leader>bB    - Buffergator open in tab
"   <C-q>         - Open quickfix window
"
" Terminal:
"   <C-t>         - Floaterm toggle
"   <Esc>         - Exit floaterm (in floaterm only)
"
" Git (vim-fugitive & gitsigns):
"   <Leader>gg    - Git status
"   <Leader>gc    - Git commit
"   <Leader>gb    - Git blame
"   <Leader>gd    - Git difftool
"   <Leader>gp    - Preview hunk (gitsigns)
"   <Leader>gs    - Stage hunk
"   <Leader>gr    - Reset hunk
"   <Leader>gS    - Stage buffer
"   <Leader>gR    - Reset buffer
"   <Leader>gB    - Toggle line blame
"
" Debugging (vimspector):
"   <Leader>dd    - Launch debugger
"   <Leader>dx    - Stop debugger
"   <Leader>db    - Toggle breakpoint
"   <Leader>dc    - Continue
"   <Leader>ds    - Step into
"   <Leader>dn    - Step over
"   <Leader>df    - Step out
"
" Other Tools:
"   <F5>          - UndoTree toggle
"   <F8>          - Tagbar toggle
"   <C-u>         - SpeedDating increment (OVERRIDES Vim scroll up!)
"   <C-d>         - SpeedDating decrement (OVERRIDES Vim scroll down!)
"   r             - Redo (custom mapping)
"   <Leader>cf    - Clang format
"   <Leader>s     - Spell ignore word
"
" KNOWN CONFLICTS:
" - <C-u>/<C-d> override Vim's native scroll commands (SpeedDating plugin)
" - <C-k> was changed from window navigation to LSP hover
"   (use <A-Up> for window navigation instead)
"
" ============================================================================

" Visual mode: Keep selection after indent {{{
vnoremap < <gv
vnoremap > >gv
" }}}

" Window navigation {{{
" NOTE: <C-k> is reserved for LSP hover in buffers with LSP attached
" Use <A-Up> for upward window navigation to avoid conflicts with LSP
nmap <silent> <a-up> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>
" }}}

" Window resizing {{{
map <a-l> :vertical res -5<CR>
map <a-h> :vertical res +5<CR>
map <a-j> :res -5<CR>
map <a-k> :res +5<CR>
" }}}

" Fast movement {{{
nnoremap <S-h> 5h
vnoremap <S-h> 5h
nnoremap <S-l> 5l
vnoremap <S-l> 5l
nnoremap <S-j> 5j
vnoremap <S-j> 5j
nnoremap <S-k> 5k
vnoremap <S-k> 5k
" }}}

" Redo mapping {{{
nmap r :redo<CR>
" }}}

" Quickfix mappings {{{
nnoremap <C-q> :copen<CR>
" }}}

" }}}

" ============================================================================
" 4. PLUGIN DECLARATIONS {{{
" ============================================================================

call plug#begin()
	" Color schemes
	Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
	Plug 'morhetz/gruvbox'

	" UI enhancements
	Plug 'akinsho/bufferline.nvim', { 'tag': 'v4.9.0' }
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'ryanoasis/vim-devicons'

	" File navigation
	Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
	Plug 'jeetsukumaran/vim-buffergator'
	Plug 'majutsushi/tagbar'

	" Git integration
	Plug 'lewis6991/gitsigns.nvim'
	Plug 'tpope/vim-fugitive'

	" Code completion and LSP
	Plug 'neovim/nvim-lspconfig'

	" Code analysis and linting
	Plug 'dense-analysis/ale'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'p00f/nvim-ts-rainbow'

	" Development tools
	Plug 'puremourning/vimspector'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-dispatch'
	Plug 'voldikss/vim-floaterm'
	Plug 'mbbill/undotree'

	" Language-specific plugins
	Plug 'vim-scripts/c.vim'
	Plug 'vim-scripts/DoxygenToolkit.vim'
	Plug 'lervag/vimtex'
	Plug 'habamax/vim-asciidoctor'
	Plug 'stsewd/sphinx.nvim'
	Plug 'pangloss/vim-javascript'
	Plug 'leafgarland/typescript-vim'
	Plug 'MaxMEllon/vim-jsx-pretty'
	Plug 'jparise/vim-graphql'

	" Note-taking and organization
	Plug 'vimwiki/vimwiki'
	Plug 'nvim-orgmode/orgmode'

	" Utilities
	Plug 'tpope/vim-speeddating'
	Plug 'inkarkat/vim-ingo-library'
	Plug 'inkarkat/vim-AdvancedSorters'
	Plug 'vim-scripts/SpellCheck'
	Plug 'junegunn/goyo.vim'
	Plug 'dhruvasagar/vim-table-mode'
	Plug 'kkvh/vim-docker-tools'
	Plug 'ledger/vim-ledger'

	" Commented out plugins (keep for reference)
	" Plug 'airblade/vim-gitgutter'
	" Plug 'elpiloto/significant.nvim'
	" Plug '~/.config/nvim/mrtee'
	" Plug 'dhruvasagar/vim-dotoo'
	" Plug 'hrsh7th/nvim-compe'
	" Plug 'github/copilot.vim'
	" Plug 'madox2/vim-ai'
call plug#end()

" Auto-install plugins if missing
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	\| :PlugInstall --sync
\| endif

" }}}

" ============================================================================
" 5. COLORSCHEME {{{
" ============================================================================

" Configure catppuccin before loading
lua << EOF
local ok, catppuccin = pcall(require, "catppuccin")
if ok then
	catppuccin.setup({
		flavour = "mocha", -- latte, frappe, macchiato, mocha
		background = {
			light = "latte",
			dark = "mocha",
		},
		transparent_background = false,
		show_end_of_buffer = false,
		term_colors = true,
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.15,
		},
		styles = {
			comments = { "italic" },
			conditionals = { "italic" },
		},
		integrations = {
			coc_nvim = false,
			gitsigns = true,
			nvimtree = true,
			treesitter = true,
			native_lsp = {
				enabled = true,
			},
		},
	})
end
EOF

set background=dark
colorscheme catppuccin

" }}}

" ============================================================================
" 6. PLUGIN CONFIGURATIONS {{{
" ============================================================================

" Plugin: akinsho/bufferline.nvim {{{
if has_key(g:plugs, 'bufferline.nvim') && isdirectory(g:plugs['bufferline.nvim'].dir)
	lua << EOF
		local ok, bufferline = pcall(require, "bufferline")
		if ok then
			bufferline.setup{}
		end
EOF
endif
" }}}

" Plugin: dense-analysis/ale {{{
if has_key(g:plugs, 'ale') && isdirectory(g:plugs['ale'].dir)
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
	let g:ale_completion_enabled = 0  " Disable ALE completion, use LSP instead
	let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
	let g:ale_set_balloons=1
	let g:ale_hover_to_floating_preview=1
	let g:ale_use_global_executables = 1
	let g:ale_sign_column_always = 1
	let g:ale_disable_lsp = 1  " Let nvim-lspconfig handle LSP

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

	" Diagnostics
	let g:ale_use_neovim_diagnostics_api = 1
	let g:airline#extensions#ale#enabled = 1
endif
" }}}

" Plugin: dhruvasagar/vim-dotoo {{{
if has_key(g:plugs, 'vim-dotoo') && isdirectory(g:plugs['vim-dotoo'].dir)
	let g:dotoo#agenda#files = ['~/vimwiki/*.dotoo']
endif
" }}}

" Plugin: habamax/vim-asciidoctor {{{
if has_key(g:plugs, 'vim-asciidoctor') && isdirectory(g:plugs['vim-asciidoctor'].dir)
	let g:asciidoctor_folding = 1
	let g:asciidoctor_fold_options = 1
	let g:asciidoctor_fenced_languages = ['lua', 'vim', 'sh', 'python', 'c', 'javascript']
endif
" }}}

" Plugin: hrsh7th/nvim-compe {{{
if has_key(g:plugs, 'nvim-compe') && isdirectory(g:plugs['nvim-compe'].dir)
	set completeopt=menuone,noselect
	let g:compe = {}
	let g:compe.enabled = v:true
	let g:compe.autocomplete = v:true
	let g:compe.debug = v:false
	let g:compe.min_length = 1
	let g:compe.preselect = 'enable'
	let g:compe.throttle_time = 80
	let g:compe.source_timeout = 200
	let g:compe.resolve_timeout = 800
	let g:compe.incomplete_delay = 400
	let g:compe.max_abbr_width = 100
	let g:compe.max_kind_width = 100
	let g:compe.max_menu_width = 100
	let g:compe.documentation = v:true
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

" Plugin: lervag/vimtex {{{
let g:tex_flavor = 'latex'
" }}}

" Plugin: lewis6991/gitsigns.nvim {{{
if has_key(g:plugs, 'gitsigns.nvim') && isdirectory(g:plugs['gitsigns.nvim'].dir)
	lua << EOF
		local ok, gitsigns = pcall(require, "gitsigns")
		if not ok then
			return
		end
		gitsigns.setup{
			signs = {
				add          = { text = '│' },
				change       = { text = '│' },
				delete       = { text = '_' },
				topdelete    = { text = '‾' },
				changedelete = { text = '~' },
				untracked    = { text = '┆' },
			},
			attach_to_untracked = true,
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = 'eol',
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
if has_key(g:plugs, 'vim-ai') && isdirectory(g:plugs['vim-ai'].dir)
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
endif
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


" Plugin: neovim/nvim-lspconfig {{{
" =============================================================================
" LSP CONFIGURATION WITH FLOATING WINDOWS
" =============================================================================
" 
" FLOATING WINDOW FEATURES (ENABLED):
" - Hover documentation (Ctrl-K, K, or gh) - Shows in floating window
" - Signature help (gK, Ctrl-S in insert mode, or Alt-K) - Floating window
" - Auto-triggered signature help when typing '('
" - Diagnostics (<Space>e to open diagnostic float)
" 
" CLOSING FLOATING WINDOWS:
" - Press <Esc> to close any floating window (most convenient)
" - Press 'q' if the window is focused
" - Move cursor to auto-close (CursorMoved event)
" - Press Ctrl-K again to toggle off
" 
" INLAY HINTS (DISABLED BY DEFAULT):
" - Inlay hints are OFF to avoid interfering with editing
" - Use :ToggleInlayHints or <leader>ih to enable temporarily if needed
" - These show inline type annotations (parameter names, inferred types)
" 
" KEY CHANGES:
" - Removed Ctrl-K conflict with window navigation (now use Alt-Up)
" - Configured floating window borders (rounded style)
" - Added auto-trigger for signature help on '('
" - Fixed deprecated diagnostic handler API
" - Inlay hints disabled by default, but can be toggled on demand
" - Escape key closes all floating windows
" 
" TESTING:
" - Run :LspTestHover to test floating windows
" - Run :LspStatus to check LSP client status
" - Place cursor on a symbol and press Ctrl-K to see hover documentation
" 
" =============================================================================
lua << EOF
-- Load lspconfig (required after removing coc.nvim)
local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
	vim.notify("⚠️  nvim-lspconfig not found! LSP features won't work.", vim.log.levels.WARN)
	vim.notify("Install it with :PlugInstall or add: Plug 'neovim/nvim-lspconfig'", vim.log.levels.WARN)
	return
end

-- Configure language servers using lspconfig
-- These will auto-start when you open matching file types

-- Vim script LSP
lspconfig.vimls.setup {}

-- Docker LSP
lspconfig.dockerls.setup {}

-- Python LSP
lspconfig.pyright.setup {}

-- Tailwind CSS LSP
lspconfig.tailwindcss.setup {}

-- Robot Framework LSP
lspconfig.robotframework_ls.setup {}

-- TypeScript/JavaScript LSP with inlay hints enabled
lspconfig.ts_ls.setup {
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "typescript.tsx" },
	cmd = { "typescript-language-server", "--stdio" },
	init_options = {
		preferences = {
			-- Disable inlay hints for TypeScript/JavaScript (they interfere with editing)
			includeInlayParameterNameHints = "none",
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = false,
			includeInlayVariableTypeHints = false,
			includeInlayPropertyDeclarationTypeHints = false,
			includeInlayFunctionLikeReturnTypeHints = false,
			includeInlayEnumMemberValueHints = false,
		}
	},
}

-- Clangd with custom config for Zephyr RTOS support
-- Function to find compile_commands.json in Zephyr build directories
local function find_zephyr_compile_commands()
	-- Common Zephyr build directory patterns
	local build_dirs = {
		"build",
		"build_output",
		"build/zephyr",
		vim.fn.getcwd() .. "/build",
	}
	
	-- Try to find compile_commands.json in various build directories
	for _, dir in ipairs(build_dirs) do
		local compile_commands = dir .. "/compile_commands.json"
		if vim.fn.filereadable(compile_commands) == 1 then
			return dir
		end
	end
	
	-- Also search for any build subdirectories (e.g., build/nrf5340dk/...)
	local handle = io.popen('find . -name "compile_commands.json" -type f 2>/dev/null | head -n 1')
	if handle then
		local result = handle:read("*a")
		handle:close()
		if result and result ~= "" then
			-- Extract directory from the path
			local dir = result:match("(.*/)")
			if dir then
				return dir:gsub("\n", ""):gsub("/$", "")
			end
		end
	end
	
	return nil
end

-- Enhanced clangd configuration
local clangd_cmd = {
	"clangd",
	"--background-index",
	"--clang-tidy",
	"--completion-style=detailed",
	"--header-insertion=never",
	"--cross-file-rename",
	"--query-driver=/usr/bin/*-gcc,/usr/bin/*-g++,/opt/*/bin/*-gcc,/opt/*/bin/*-g++",
}

-- Try to find and add compile commands directory
local compile_commands_dir = find_zephyr_compile_commands()
if compile_commands_dir then
	table.insert(clangd_cmd, "--compile-commands-dir=" .. compile_commands_dir)
end

-- Clangd LSP with Zephyr support and inlay hints
lspconfig.clangd.setup {
	cmd = clangd_cmd,
	filetypes = { "c", "cpp", "h" },
	root_dir = function(fname)
		-- Look for common Zephyr project markers
		return vim.fs.dirname(vim.fs.find({
			'compile_commands.json',
			'.clangd',
			'.git',
			'west.yml',
			'zephyr',
			'CMakeLists.txt',
		}, { upward = true, path = fname })[1])
	end,
	init_options = {
		clangdFileStatus = true,
		usePlaceholders = false,
		completeUnimported = false,
		semanticHighlighting = true,
	},
	settings = {
		clangd = {
			InlayHints = {
				Enabled = false,
				ParameterNames = false,
				DeducedTypes = false,
			},
		},
	},
}

-- Global completion settings
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- Global diagnostic mappings (work in all buffers)
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = 'LSP: Show diagnostics in floating window' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'LSP: Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'LSP: Go to next diagnostic' })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = 'LSP: Add diagnostics to location list' })

-- Easy way to close any floating window: Escape or Ctrl-c
vim.keymap.set('n', '<Esc>', function()
	-- Close any LSP floating windows
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= '' then  -- It's a floating window
			vim.api.nvim_win_close(win, false)
		end
	end
end, { desc = 'Close floating windows', silent = true })

-- Completion keybindings (works in insert mode)
vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', { noremap = true, silent = true, desc = 'Trigger completion' })
vim.keymap.set('i', '<C-n>', '<C-n>', { noremap = true, silent = true, desc = 'Next completion' })
vim.keymap.set('i', '<C-p>', '<C-p>', { noremap = true, silent = true, desc = 'Previous completion' })

-- LspAttach autocommand
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Get the client that attached
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		
		-- Notify that LSP attached
		if client then
			print(string.format("LSP attached: %s (buffer %d)", client.name, ev.buf))
		end
		
		-- Enable omnifunc completion
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
		
		-- Disable inlay hints by default (they interfere with editing)
		-- Use :ToggleInlayHints or <leader>ih to enable temporarily if needed
		if client and client.server_capabilities and client.server_capabilities.inlayHintProvider then
			pcall(function()
				if vim.lsp.inlay_hint then
					vim.lsp.inlay_hint.enable(false, { bufnr = ev.buf })
				end
			end)
		end

		local opts = { buffer = ev.buf }
		
		-- Code navigation
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'LSP: Go to declaration' }))
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'LSP: Go to definition' }))
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'LSP: Go to implementation' }))
		
		-- References with automatic quickfix open
		vim.keymap.set('n', 'gr', function()
			vim.lsp.buf.references()
			-- Wait a bit for references to populate, then open quickfix
			vim.defer_fn(function()
				vim.cmd('copen')
			end, 100)
		end, vim.tbl_extend('force', opts, { desc = 'LSP: Find references' }))
		
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = 'LSP: Go to type definition' }))
		
		-- Documentation and help (multiple keys for convenience)
		-- Ctrl-K: Primary hover key in both normal and insert mode
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'LSP: Show hover documentation' }))
		vim.keymap.set('i', '<C-k>', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'LSP: Show hover documentation' }))
		-- K: Standard Vim key for documentation
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'LSP: Show hover documentation' }))
		-- gh: Alternative (mnemonic: "go hover")
		vim.keymap.set('n', 'gh', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'LSP: Show hover documentation' }))
		
		-- Signature help (function parameters) - also auto-triggers on '('
		vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'LSP: Show signature help' }))
		vim.keymap.set('i', '<M-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'LSP: Show signature help' }))  -- Alt-K in insert mode
		vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'LSP: Show signature help' }))  -- Ctrl-S in insert mode (alternative)
		
		-- Code actions and refactoring
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'LSP: Code action' }))
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'LSP: Rename symbol' }))
		
		-- Workspace management
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend('force', opts, { desc = 'LSP: Add workspace folder' }))
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend('force', opts, { desc = 'LSP: Remove workspace folder' }))
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, vim.tbl_extend('force', opts, { desc = 'LSP: List workspace folders' }))
		
		-- Formatting
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, vim.tbl_extend('force', opts, { desc = 'LSP: Format buffer' }))
	end,
})

-- Command to toggle inlay hints on/off
vim.api.nvim_create_user_command('ToggleInlayHints', function()
	local buf = vim.api.nvim_get_current_buf()
	if vim.lsp.inlay_hint then
		local current = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
		vim.lsp.inlay_hint.enable(not current, { bufnr = buf })
		print(string.format("Inlay hints %s", not current and "enabled" or "disabled"))
	else
		print("Inlay hints not supported in this Neovim version")
	end
end, { desc = "Toggle LSP inlay hints in current buffer" })

-- Keybinding to toggle inlay hints: <leader>ih
vim.keymap.set('n', '<leader>ih', ':ToggleInlayHints<CR>', { desc = 'Toggle inlay hints', silent = true })

-- Command to test LSP hover and floating windows
vim.api.nvim_create_user_command('LspTestHover', function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		print("❌ No LSP clients attached!")
		print("Make sure you're in a file with LSP support (e.g., .c, .py, .ts)")
		return
	end
	
	print("✅ LSP clients found: " .. #clients)
	print("Testing hover... Place cursor on a symbol and press Ctrl-K or K")
	print("A floating window should appear with documentation")
	
	-- Show a test floating window to verify floating windows work
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
		"✅ Floating Windows Are Working!",
		"",
		"If you can see this, floating windows are configured correctly.",
		"",
		"To test LSP hover:",
		"1. Place cursor on a function or variable",
		"2. Press Ctrl-K, K, or gh",
		"3. Documentation should appear in a floating window",
		"",
		"Press 'q' or <Esc> to close this window",
	})
	
	local win = vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = 60,
		height = 12,
		col = (vim.o.columns - 60) / 2,
		row = (vim.o.lines - 12) / 2,
		style = 'minimal',
		border = 'rounded',
	})
	
	-- Close on q or Esc
	vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', { noremap = true, silent = true })
end, { desc = "Test LSP hover and floating window functionality" })

-- Command to check LSP status
vim.api.nvim_create_user_command('LspStatus', function()
	local buf = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = buf })
	local ft = vim.bo[buf].filetype
	
	print("=== LSP Status ===")
	print(string.format("Filetype: %s", ft))
	print(string.format("Buffer: %d", buf))
	print(string.format("File: %s", vim.api.nvim_buf_get_name(buf)))
	
	if #clients == 0 then
		print("\n❌ No LSP clients attached to this buffer!")
		print("\nTroubleshooting:")
		print("  1. Check if LSP server is installed: :checkhealth lsp")
		print("  2. Try restarting LSP: :LspRestart")
		print("  3. Check LSP logs: :LspLog")
	else
		print("\n✅ LSP Clients Attached:")
		for _, client in ipairs(clients) do
			print(string.format("  - %s (id: %d)", client.name, client.id))
			if client.server_capabilities then
				print("    Capabilities:")
				print(string.format("      definitionProvider: %s", tostring(client.server_capabilities.definitionProvider ~= nil)))
				print(string.format("      referencesProvider: %s", tostring(client.server_capabilities.referencesProvider ~= nil)))
				print(string.format("      hoverProvider: %s", tostring(client.server_capabilities.hoverProvider ~= nil)))
			end
		end
	end
	
	-- Check keymaps
	print("\n=== LSP Keymaps (for current buffer) ===")
	local keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')
	local lsp_keymaps = {}
	for _, keymap in ipairs(keymaps) do
		if keymap.lhs == 'gd' or keymap.lhs == 'gi' or keymap.lhs == 'gr' or keymap.lhs == 'K' then
			table.insert(lsp_keymaps, keymap.lhs)
		end
	end
	
	if #lsp_keymaps > 0 then
		print("  ✅ Found: " .. table.concat(lsp_keymaps, ", "))
	else
		print("  ❌ No LSP keymaps found (gd, gi, gr, K)")
		print("     LSP may not have attached properly")
	end
end, { desc = "Check LSP status and keybindings" })

-- Command to diagnose inlay hints status
vim.api.nvim_create_user_command('DiagnoseInlayHints', function()
	local buf = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = buf })
	
	print("=== Inlay Hints Diagnostic ===")
	print(string.format("Buffer: %d | File: %s", buf, vim.api.nvim_buf_get_name(buf)))
	
	if #clients == 0 then
		print("\n❌ No LSP clients attached to this buffer")
		return
	end
	
	print("\n=== LSP Clients ===")
	local has_inlay_support = false
	for _, client in ipairs(clients) do
		print(string.format("  - %s (id: %d)", client.name, client.id))
		if client.server_capabilities and client.server_capabilities.inlayHintProvider then
			print("    ✅ Supports inlay hints")
			has_inlay_support = true
		else
			print("    ❌ Does not support inlay hints")
		end
	end
	
	-- Check inlay hint status
	if vim.lsp.inlay_hint then
		local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
		print("\n=== Inlay Hint Status ===")
		if enabled then
			print("  ✅ Inlay hints are ENABLED for this buffer")
		else
			print("  ❌ Inlay hints are DISABLED for this buffer")
			print("  💡 Run :ToggleInlayHints or press <leader>ih to enable")
		end
	else
		print("\n❌ Inlay hints API not available (Neovim too old?)")
	end
	
	if not has_inlay_support then
		print("\n⚠️  None of the attached LSP servers support inlay hints")
		print("   Make sure you're using a language server that supports them:")
		print("   - clangd (C/C++)")
		print("   - rust-analyzer (Rust)")
		print("   - typescript-language-server (TypeScript/JavaScript)")
		print("   - gopls (Go)")
	end
	
	-- Check for virtual text in buffer
	print("\n=== Virtual Text (Extmarks) ===")
	local namespaces = vim.api.nvim_get_namespaces()
	local found_any = false
	for name, ns_id in pairs(namespaces) do
		local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns_id, 0, -1, {})
		if #extmarks > 0 then
			print(string.format("  - %s: %d extmarks", name, #extmarks))
			found_any = true
		end
	end
	if not found_any then
		print("  No extmarks found (this is normal if hints aren't showing)")
	end
end, { desc = "Diagnose inlay hints status and configuration" })

-- Configure floating windows for LSP
local border_style = "rounded"
local float_config = {
	border = border_style,
	max_width = 80,
	max_height = 20,
}

-- Hover handler with floating window (focusable so you can close with q or Esc)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers.hover, {
		border = border_style,
		max_width = 80,
		max_height = 20,
		focusable = true,  -- Allow focusing the window to close it
		close_events = {"CursorMoved", "CursorMovedI", "InsertEnter"},  -- Auto-close on cursor move
	}
)

-- Signature help handler with floating window
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
	vim.lsp.handlers.signature_help, {
		border = border_style,
		max_width = 80,
		max_height = 20,
		focusable = true,
		close_events = {"CursorMoved", "CursorMovedI", "BufLeave"},
	}
)

-- Note: Diagnostics are configured via vim.diagnostic.config below, not via handlers

-- Configure diagnostic floating windows and display
vim.diagnostic.config({
	virtual_text = false,  -- Disable inline diagnostic text
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = border_style,
		source = "always",
		header = "",
		prefix = "",
		focusable = true,
		max_width = 80,
		max_height = 20,
	},
})

-- Auto-trigger signature help when typing opening parenthesis
vim.api.nvim_create_autocmd("InsertCharPre", {
	group = vim.api.nvim_create_augroup("LspSignatureHelp", { clear = true }),
	pattern = "*",
	callback = function()
		if vim.v.char == "(" then
			-- Delay slightly to let the character be inserted first
			vim.defer_fn(function()
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if #clients > 0 then
					vim.lsp.buf.signature_help()
				end
			end, 50)
		end
	end,
})
EOF
" }}}

" Plugin: nvim-orgmode/orgmode {{{
if has_key(g:plugs, 'orgmode') && isdirectory(g:plugs['orgmode'].dir)
	lua << EOF
	local ok, orgmode = pcall(require, 'orgmode')
	if ok then
		orgmode.setup({
			org_agenda_files = {'~/board.org'},
			org_default_notes_file = '~/refile.org',
		})
	end
EOF
endif
" }}}

" Plugin: nvim-treesitter/nvim-treesitter {{{
if has_key(g:plugs, 'nvim-treesitter') && isdirectory(g:plugs['nvim-treesitter'].dir)
	lua << EOF
		local ok, treesitter = pcall(require, 'nvim-treesitter.configs')
		if not ok then
			return
		end
		treesitter.setup {
			highlight = {
				enable = true,
				extended_mode = true,
				use_languagetree = true,
				disable = {},
			},
			rainbow = {
				enable = true,
				extended_mode = true,
				max_file_lines = nil,
				colors = {},
				termcolors = {}
			},
			ensure_installed = {'c'},
		}
EOF
endif
" }}}

" Plugin: preservim/nerdtree {{{
let g:NERDTreeWinSize = 40
let NERDTreeIgnore = ['\.o$', '\.obj$', '\.a$', '\.so$', '\.out$', '\.git$']
let NERDTreeShowHidden = 1
let NERDTreeShowBookmarks = 1
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
nnoremap <C-n> :NERDTreeToggle<CR>

" Custom NERDTree function to copy absolute path
function! NERDTreeYankPath()
	let n = g:NERDTreeFileNode.GetSelected()
	if n != {}
		let path = n.path.str()
		call setreg('+', path)
		echo "Copied: " . path
	endif
endfunction
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

" Plugin: tpope/vim-fugitive {{{
nnoremap <Leader>gg :Git<CR>
nnoremap <Leader>gi :Git status<CR>
nnoremap <Leader>gc :Git commit<CR>
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gd :Git difftool<CR>
nnoremap <Leader>gm :Git mergetool<CR>
nnoremap <Leader>gdv :Gvdiffsplit<CR>
nnoremap <Leader>gdh :Gdiffsplit<CR>
" }}}

" Plugin: tpope/vim-speeddating {{{
let g:speeddating_no_mappings = 1
nmap <C-u> <Plug>SpeedDatingUp
nmap <C-d> <Plug>SpeedDatingDown
xmap <C-u> <Plug>SpeedDatingUp
xmap <C-d> <Plug>SpeedDatingDown
nmap <leader>sdu <Plug>SpeedDatingNowUTC
nmap <leader>sdi <Plug>SpeedDatingNowLocal
" }}}

" Plugin: vim-airline/vim-airline {{{
let g:airline_powerline_fonts = 1
let g:airline_theme = 'deus'
let g:airline#extensions#wordcount#enabled = 1
let g:airline#extensions#wordcount#filetypes = 'notes|help|markdown|rst|org|text|asciidoctor|tex|mail|plaintext|context'
" }}}

" Plugin: vimwiki/vimwiki {{{
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
" }}}

" Plugin: voldikss/vim-floaterm {{{
nnoremap <C-t> :FloatermToggle!<CR>
tnoremap <Esc> <C-\><C-n>:FloatermToggle<CR>
" }}}

" }}}

" ============================================================================
" 7. CUSTOM FUNCTIONS AND COMMANDS {{{
" ============================================================================

" Function: ClangFormat {{{
function! ClangFormat()
	let l:lines = 'lines=' . (line("'>")-line("'<")+1)
	let l:format_command = 'clang-format -style=file -assume-filename=% -'.l:lines
	execute ":'<,'>! ".l:format_command
endfunction

nnoremap <leader>cf :call ClangFormat()<CR>
vnoremap <leader>cf :call ClangFormat()<CR>
" }}}

" Function: ModifyTextWidth (for markdown links) {{{
function! ModifyTextWidth()
	if getline(".")=~'^.*\[.*\](.*)$'
		setlocal textwidth=500
	else
		setlocal textwidth=80
	endif
endfunction
" }}}

" Function: SetClangTidyConfig {{{
function! SetClangTidyConfig()
	let l:config_file = findfile('.clang-tidy', expand('%:p:h').';')
	if !empty(l:config_file)
		let g:ale_c_clangtidy_options = '--config=' . l:config_file
		let g:ale_cpp_clangtidy_options = '--config=' . l:config_file
	endif
endfunction
" }}}

" Function: ZephyrSwitchBuild - Switch clangd to use different Zephyr build directory {{{
function! ZephyrSwitchBuild(build_dir)
	lua << EOF
		local build_dir = vim.fn.eval('a:build_dir')
		local compile_commands = build_dir .. "/compile_commands.json"
		
		if vim.fn.filereadable(compile_commands) == 0 then
			vim.notify("compile_commands.json not found in: " .. build_dir, vim.log.levels.ERROR)
			return
		end
		
		-- Stop all running clangd clients
		for _, client in ipairs(vim.lsp.get_clients()) do
			if client.name == 'clangd' then
				vim.lsp.stop_client(client.id)
			end
		end
		
		-- Update clangd command with new build directory
		local lspconfig = require('lspconfig')
		local clangd_cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--completion-style=detailed",
			"--header-insertion=never",
			"--cross-file-rename",
			"--query-driver=/usr/bin/*-gcc,/usr/bin/*-g++,/opt/*/bin/*-gcc,/opt/*/bin/*-g++",
			"--compile-commands-dir=" .. build_dir,
		}
		
		lspconfig.clangd.setup {
			cmd = clangd_cmd,
			filetypes = { "c", "cpp", "h" },
		}
		
		-- Restart by editing the file again
		vim.cmd('edit')
		vim.notify("Switched to build directory: " .. build_dir, vim.log.levels.INFO)
EOF
endfunction

" Function: ZephyrLinkBuild - Create symlink to compile_commands.json
function! ZephyrLinkBuild(...)
	lua << EOF
		local build_dir = nil
		local args = vim.fn.eval('a:000')
		
		-- Function to actually create the symlink
		local function create_symlink(dir)
			local source = dir .. '/compile_commands.json'
			local target = vim.fn.getcwd() .. '/compile_commands.json'
			
			if vim.fn.filereadable(source) == 0 then
				vim.notify("compile_commands.json not found in: " .. dir, vim.log.levels.ERROR)
				return
			end
			
			local cmd = 'ln -sf ' .. vim.fn.shellescape(source) .. ' ' .. vim.fn.shellescape(target)
			local result = vim.fn.system(cmd)
			
			if vim.v.shell_error == 0 then
				vim.notify("Created symlink: " .. target .. " -> " .. source, vim.log.levels.INFO)
				-- Restart LSP to pick up the new compile_commands.json
				vim.cmd('LspRestart')
			else
				vim.notify("Failed to create symlink: " .. result, vim.log.levels.ERROR)
			end
		end
		
		-- If no argument provided, show interactive list
		if #args == 0 then
			-- Find all compile_commands.json files
			local find_cmd = 'find . -name "compile_commands.json" -type f 2>/dev/null'
			local result = vim.fn.system(find_cmd)
			
			if vim.v.shell_error ~= 0 or result == "" then
				vim.notify("No compile_commands.json files found in project", vim.log.levels.WARN)
				return
			end
			
			-- Parse the results and extract directories
			local builds = {}
			for line in result:gmatch("[^\r\n]+") do
				-- Extract directory from the path (remove /compile_commands.json)
				local dir = line:match("(.*/)")
				if dir then
					dir = dir:gsub("/$", "")  -- Remove trailing slash
					dir = dir:gsub("^%./", "")  -- Remove leading ./
					table.insert(builds, dir)
				end
			end
			
			if #builds == 0 then
				vim.notify("No build directories found", vim.log.levels.WARN)
				return
			end
			
			-- Show interactive selection
			vim.ui.select(builds, {
				prompt = 'Select Zephyr build directory:',
				format_item = function(item)
					return item
				end,
			}, function(choice)
				if choice then
					create_symlink(choice)
				end
			end)
		else
			-- Argument provided, use it directly
			build_dir = args[1]
			create_symlink(build_dir)
		end
EOF
endfunction

" Function: ZephyrSelectBuild - Interactive build directory selection for ZephyrBuild
function! ZephyrSelectBuild(...)
	lua << EOF
		local args = vim.fn.eval('a:000')
		
		-- Function to switch to a build directory
		local function switch_build(dir)
			vim.fn.ZephyrSwitchBuild(dir)
		end
		
		-- If no argument, show interactive list
		if #args == 0 then
			local find_cmd = 'find . -name "compile_commands.json" -type f 2>/dev/null'
			local result = vim.fn.system(find_cmd)
			
			if vim.v.shell_error ~= 0 or result == "" then
				vim.notify("No compile_commands.json files found in project", vim.log.levels.WARN)
				return
			end
			
			local builds = {}
			for line in result:gmatch("[^\r\n]+") do
				local dir = line:match("(.*/)")
				if dir then
					dir = dir:gsub("/$", "")
					dir = dir:gsub("^%./", "")
					table.insert(builds, dir)
				end
			end
			
			if #builds == 0 then
				vim.notify("No build directories found", vim.log.levels.WARN)
				return
			end
			
			vim.ui.select(builds, {
				prompt = 'Select Zephyr build directory:',
				format_item = function(item)
					return item
				end,
			}, function(choice)
				if choice then
					vim.fn.ZephyrSwitchBuild(choice)
				end
			end)
		else
			vim.fn.ZephyrSwitchBuild(args[1])
		end
EOF
endfunction

" Commands for Zephyr build management
command! -nargs=? -complete=dir ZephyrBuild call ZephyrSelectBuild(<f-args>)
command! -nargs=? -complete=dir ZephyrLinkBuild call ZephyrLinkBuild(<f-args>)

" Quick command to find all build directories with compile_commands.json
command! ZephyrListBuilds lua vim.notify(vim.fn.system('find . -name "compile_commands.json" -type f'), vim.log.levels.INFO)
" }}}

" Command: SpellIgnore {{{
command! SpellIgnore :call execute('spell! ' . expand('<cword>'))
nnoremap <Leader>s :call execute('spell! ' . expand('<cword>'))<CR>
" }}}

" LSP Helper Commands {{{
" Check which LSP servers are attached to current buffer
command! LspClients lua vim.notify(vim.inspect(vim.lsp.get_clients()), vim.log.levels.INFO)

" Show detailed LSP info for current buffer (this is provided by lspconfig)
command! LspInfo LspInfo

" Restart LSP servers for current buffer
command! LspRestart lua vim.cmd('LspRestart')

" Show compile_commands.json location
command! LspCompileCommands lua print('Looking for: ' .. vim.fn.getcwd() .. '/compile_commands.json') | print('Exists: ' .. (vim.fn.filereadable(vim.fn.getcwd() .. '/compile_commands.json') == 1 and 'YES' or 'NO'))
" }}}

" }}}

" ============================================================================
" 8. AUTOCOMMANDS {{{
" ============================================================================

" Highlight trailing whitespace {{{
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
augroup TrailingWhitespace
	autocmd!
	autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()
	autocmd FileType floaterm highlight clear ExtraWhitespace
augroup END
let c_space_errors = 1
" }}}

" Filetype: Vim script {{{
augroup VimScriptExtras
	au!
	au FileType vim vnoremap <buffer> <C-r> "*y \| <Esc>:@*<CR>
augroup END
" }}}

" Filetype: Quickfix {{{
augroup QuickFixGroup
	au!
	au FileType qf nnoremap <buffer> n :cnext<CR>
	au FileType qf nnoremap <buffer> p :cprev<CR>
	au FileType qf nnoremap <buffer> <C-i> :cclose<CR>
augroup END
" }}}

" Filetype: Markdown {{{
augroup MarkdownSettings
	au!
	au CursorMovedI *.md call ModifyTextWidth()
augroup END
" }}}

" Filetype: NERDTree {{{
augroup NERDTreeSettings
	au!
	au FileType nerdtree setlocal nolist
	au FileType nerdtree nnoremap <buffer> yy :call NERDTreeYankPath()<CR>
	au FileType nerdtree nnoremap <buffer> b :Bookmark<CR>
	au FileType nerdtree nmap <buffer> d D
augroup END
" }}}

" Filetype: Floaterm {{{
augroup FloattermMapping
	autocmd!
	autocmd FileType floaterm nnoremap <buffer> <Esc> <C-\><C-n>:FloatermToggle<CR>
	autocmd FileType floaterm inoremap <buffer> <Esc> <C-\><C-n>:FloatermToggle<CR>
augroup END
" }}}

" Filetype: Ledger {{{
augroup LedgerSettings
	au!
	au BufRead,BufNewFile *.ledger,*.ldg set filetype=ledger
	au FileType ledger setlocal includeexpr=substitute(v:fname,'^.*[\\/]\zs','','')
augroup END
" }}}

" Filetype: Dotoo {{{
augroup DotooSettings
	au!
	au BufRead,BufNewFile *.dotoo set filetype=dotoo
augroup END
" }}}

" Filetype: C/C++ - ALE {{{
augroup ALECLanguages
	au!
	au FileType c nnoremap <leader>f <Plug>(ale_fix)
	au BufRead,BufNewFile *.c,*.cpp,*.h,*.hpp call SetClangTidyConfig()
augroup END
" }}}

" }}}

" ============================================================================
" 9. RUNTIME AND FINAL SETTINGS {{{
" ============================================================================

" Python3 configuration {{{
let g:python3_host_prog = '/usr/bin/python3'
set runtimepath+=~/.config/nvim/python/
" }}}

" Disable editorconfig {{{
lua << EOF
vim.g.editorconfig = false
EOF
" }}}

" Load TypeScript runtime {{{
runtime typescript.vim
" }}}

" }}}

