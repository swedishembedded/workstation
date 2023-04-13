syntax on

" c: autowrap comments
" r: automatically insert comment leader after enter
" o: automatically insert comment leader after hitting o
" a: automatic paragraph formatting
" n: recognise numbered lists
set formatoptions+=cron

" I like the desert color scheme
colorscheme desert

" Configure tabs
" How many columns does a tab display as?
set tabstop=4
" How many columns vim uses when you hit tab (set to same as tabstop!)
set softtabstop=4
" How many columns to use in indent and reindent operations (<< and >>)
set shiftwidth=4
" Enable autoindent when pressing enter
set autoindent
" We do not want our tabs demoted into spaces!
set noexpandtab
" Enable mouse motion and resizing
set mouse=a
" Show line numbers
set number

" Load vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin()
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'lervag/vimtex'
Plug 'tpope/vim-commentary'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'
Plug 'habamax/vim-asciidoctor'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovim/nvim-lspconfig'
Plug 'airblade/vim-gitgutter'
Plug 'hrsh7th/nvim-compe'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'p00f/nvim-ts-rainbow'
Plug 'morhetz/gruvbox'
Plug 'Yggdroot/indentLine'
Plug 'dense-analysis/ale'
Plug 'vim-scripts/c.vim'
Plug 'voldikss/vim-floaterm'
Plug 'puremourning/vimspector'
Plug 'vimwiki/vimwiki'
Plug 'dhruvasagar/vim-dotoo'
call plug#end()

" Latex editing
let g:tex_flavor = 'latex'

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Undootree
nmap <F5> :UndotreeToggle<CR>

" Org mode
let g:orgmode_enabled = 1
nnoremap <Tab> :OrgCycle<CR>
let g:org_agenda_files=['~/board.org']

" Speeddating
let g:speeddating_no_mappings = 1
nmap <C-a> <Plug>SpeedDatingIncrement
nmap <C-x> <Plug>SpeedDatingDecrement

" Set Vim-dotoo settings
let g:dotoo#agenda#files = ['~/vimwiki/*.dotoo']
au BufRead,BufNewFile *.dotoo set filetype=dotoo

" Set Vimwiki settings
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" Set the color scheme
colorscheme gruvbox
set background=dark " Optional: change to 'light' for the light version

" Configure coc.nvim for autocompletion
let g:coc_global_extensions = ['coc-clangd']
let g:clangd_install_prefix = '/usr/'
let g:clangd_command = ['clangd', '--clang-tidy', '--background-index', '--header-insertion-decorators=0', '--completion-style=detailed']

" Ale configuration
" Ignore git commit when linting (highly annoying)
let g:ale_pattern_options = {'COMMIT_EDITMSG$': {'ale_linters': [], 'ale_fixers': []}}
let g:ale_linters = {
\	'yaml': ['yamllint'],
\	'cpp': ['clangtidy'],
\	'c': ['clangtidy']}
let g:ale_fixers = {
\	'cpp': ['clang-format'],
\	'c': ['clang-format']}

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

function! SetClangTidyConfig()
    let l:config_file = findfile('.clang-tidy', expand('%:p:h').';')
    if !empty(l:config_file)
        let g:ale_c_clangtidy_options = '--config=' . l:config_file
        let g:ale_cpp_clangtidy_options = '--config=' . l:config_file
    endif
endfunction

autocmd BufRead,BufNewFile *.c,*.cpp,*.h,*.hpp call SetClangTidyConfig()

" Clang format
function! FormatCode()
    let l:filetype = &filetype
    if l:filetype == 'c' || l:filetype == 'cpp' || l:filetype == 'objc' || l:filetype == 'objcpp'
        silent %!clang-format
    endif
endfunction

nnoremap <leader>f :call FormatCode()<CR>

" Configure gitgutter
let g:gitgutter_enabled = 1

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
nnoremap <leader>s :call v:lua.vim.lsp.buf.hover()<CR>
inoremap <leader>s :call v:lua.vim.lsp.buf.hover()<CR>

" Completion setup
let g:compe = {}
let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.omni = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true
let g:compe.source.tabnine = v:true
let g:compe.source.buffer = v:true

" Keybinds
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')

" Configure nvim-compe
lua << EOF
require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = {
        border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `| help nvim_open_win|`
        winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
        max_width = 120,
        min_width = 60,
        max_height = math.floor(vim.o.lines * 0.3),
        min_height = 1,
    };

    source = {
        path = true;
        buffer = true;
        calc = true;
        nvim_lsp = true;
        nvim_lua = true;
        vsnip = false;
        ultisnips = false;
        luasnip = false;
    };
}
EOF

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

" highlight unwanted spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
let c_space_errors = 1

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

" AsciiDoc Folding
autocmd FileType asciidoc setlocal foldmethod=expr
autocmd FileType asciidoc setlocal foldexpr=AsciidoctorVimFoldLevel(v:lnum)

" Clang format
function! ClangFormat()
    let l:lines = 'lines=' . (line("'>")-line("'<")+1)
    let l:format_command = 'clang-format -style=file -assume-filename=% -'.l:lines
    execute ":'<,'>! ".l:format_command
endfunction

nnoremap <leader>cf :call ClangFormat()<CR>
vnoremap <leader>cf :call ClangFormat()<CR>

set nobackup
set noswapfile

vnoremap < <gv
vnoremap > >gv

nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

map <a-l> :vertical res +5<CR>
map <a-h> :vertical res -5<CR>
map <a-j> :res -5<CR>
map <a-k> :res +5<CR>

nmap <S-l> 10l<CR>
nmap <S-h> 10h<CR>
nmap <S-j> 10j<CR>
nmap <S-k> 10k<CR>
