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

set mouse=a

" Load vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovim/nvim-lspconfig'
Plug 'airblade/vim-gitgutter'
Plug 'akinsho/nvim-bufferline.lua'
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
Plug 'asciidoc/asciidoctor-vim'
call plug#end()

" Set Vim-dotoo settings
let g:dotoo#agenda#files = ['~/vimwiki/*.dotoo']

" Set Vimwiki settings
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" Set the color scheme
colorscheme gruvbox
set background=dark " Optional: change to 'light' for the light version

" Configure coc.nvim for autocompletion
let g:coc_global_extensions = ['coc-clangd']
let g:clangd_install_prefix = '/usr/'
let g:clangd_command = ['clangd', '--clang-tidy', '--background-index', '--header-insertion-decorators=0', '--completion-style=detailed']

" Configure gitgutter
let g:gitgutter_enabled = 1

" Configure bufferline
lua << EOF
require'bufferline'.setup{
  options = {
    modified_icon = '●',
    buffer_close_icon = '',
    show_buffer_close_icons = false,
  },
}
EOF

" Setup lsp
" Enable the C language server (clangd)
lua << EOF
require'lspconfig'.clangd.setup{
    on_attach = function(client, bufnr)
        require'completion'.on_attach(client, bufnr)
    end,
    flags = {
        debounce_text_changes = 150,
    },
    cmd = { "clangd", "--background-index" },
    filetypes = { "c", "cpp" },
}
EOF

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
let NERDTreeIgnore = ['\.o$', '\.obj$', '\.a$', '\.so$', '\.out$']
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
