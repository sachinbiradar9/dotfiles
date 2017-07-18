"line numbers
"set background=dark
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
set showcmd		" Show (partial) command in status line.
set relativenumber
set number
nnoremap <silent><F10> :set number! relativenumber!<CR>

syntax enable
filetype plugin on
filetype indent on

set path+=**
set suffixesadd=.py,.js,.html,.css
set complete-=i
set wildmode=longest:list,full "Complete longest common string and list all matched, then each full match
set wildmenu            " visual autocomplete for command menu
set showcmd             " show command in bottom bar
set pastetoggle=<F2>    " toggle paste mode
set wrap                " wrap long lines
set title               " shows the current filename and path in title.
highlight ColorColumn ctermbg=Gray
set colorcolumn=120


"TAB and space
set tabstop=4           " number of visual spaces per TAB
"set softtabstop=4      " number of spaces in tab when editing
set expandtab           " tabs are spaces
set shiftwidth=4        " number of space inserted for indentation
set list
set listchars=tab:▸\    " display ▸ for tab
highlight ExtraWhitespace ctermbg=Red guibg=Red
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
"visual selection wont be lost while indenting
vmap > >gv
vmap < <gv


"Search
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase          " ignore case when searching
set smartcase           " do not ignore case if pattern has mixed case
set showmatch           " Show matching brackets.
inoremap } }<Left><c-o>%<c-o>:sleep 500m<CR><c-o>%<c-o>a
inoremap ] ]<Left><c-o>%<c-o>:sleep 500m<CR><c-o>%<c-o>a
inoremap ) )<Left><c-o>%<c-o>:sleep 500m<CR><c-o>%<c-o>a
" in normal mode enter clears search highlight
nnoremap <silent><CR> :nohlsearch<CR>


"Folding
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
"space open/closes folds
nnoremap <space> za


"move up down on wrapped line
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
"dragging up and down
nnoremap <S-j> :m .+1<CR>==
nnoremap <S-k> :m .-2<CR>==
vnoremap <S-j> :m '>+1<CR>gv=gv
vnoremap <S-k> :m '<-2<CR>gv=gv


"file browsing
let g:netrw_banner=0 "disable annoying banner
let g:netrw_browse_split=4 "open in prior window
let g:netrw_altv=1 "open splits to the right
let g:netrw_liststyle=3 "tree view
let g:netrw_winsize = 25
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
map <silent> <C-E> :call ToggleVExplorer()<CR>


"TABS
nnoremap <silent> <C-A> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <C-D> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

set tabline=%!MyTabLine()  " custom tab pages line
function MyTabLine()
    let s = '' " complete tabline goes here
    " loop through each tab page
    for t in range(tabpagenr('$'))
        " set highlight
        if t + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        " set page number string
        let s .= ' '
        let s .= t + 1 . ' '
        " get buffer names and statuses
        let n = ''      "temp string for buffer names while we loop and check buftype
        let m = 0       " &modified counter
        let bc = len(tabpagebuflist(t + 1))     "counter to avoid last ' '
        " loop through each buffer in a tab
        for b in tabpagebuflist(t + 1)
            " buffer types: quickfix gets a [Q], help gets [H]{base fname}
            " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
            if getbufvar( b, "&buftype" ) == 'help'
                let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
            elseif getbufvar( b, "&buftype" ) == 'quickfix'
                let n .= '[Q]'
            else
                if t + 1 == tabpagenr()
                    let n .= bufname(b)
                else
                    let n .= pathshorten(bufname(b))
                endif
            endif
            " check and ++ tab's &modified count
            if getbufvar( b, "&modified" )
                    let m += 1
            endif
            " no final ' ' added...formatting looks better done later
            if bc > 1
                    let n .= ' '
            endif
            let bc -= 1
        endfor
        " add modified label [n+] where n pages in tab are modified
        if m > 0
                let s .= '[' . m . '+]'
        endif
        " add buffer names
        if n == ''
                let s.= '[New]'
        else
                let s .= n
        endif
        " add final space to buffer list
        let s .= ' '
    endfor
    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLine#%T'
    return s
endfunction



" jamessan's
"set laststatus=2
"set statusline=        " clear the statusline for when vimrc is reloaded
"set statusline+=%-3.3n\                      " buffer number
"set statusline+=%f\                          " file name
"set statusline+=%h%m%r%w                     " flags
"set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
"set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
"set statusline+=%{&fileformat}]              " file format
"set statusline+=%=                           " right align
"set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
"set statusline+=%b,0x%-8B\                   " current char
"set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset



"git config --global diff.tool vimdiff
"git config --global merge.tool vimdiff
"git config --global difftool.prompt false
"git config --global alias.d difftool
"git config --global alias.m mergetool
