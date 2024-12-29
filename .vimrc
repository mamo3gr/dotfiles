"===============================================================================
" edit
"===============================================================================
set encoding=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" undoファイルを作らない
set noundofile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
" コマンドラインの補完
set wildmenu
set wildmode=full
" スペルチェックを有効にする。C-x sで修正候補を表示
set spell
set spelllang=en,cjk

"===============================================================================
" display
"===============================================================================
" https://github.com/nanotech/jellybeans.vim
colorscheme jellybeans

filetype plugin indent on
syntax on
" 行数表示
set number
" 現在の行を強調表示
set cursorline
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
set noautoindent
" ステータスラインを常に表示
set laststatus=2
" 補完メニューの高さ
set pumheight=10
" 長い行があった場合
set display=lastline
" 不可視文字を可視化(タブが「▸-」と表示される)。行末のスペースを可視化
set list listchars=tab:\▸\-,trail:~
" 対応する括弧やブレースを表示
set showmatch matchtime=1
" エラーメッセージの表示時にビープを鳴らさない
set noerrorbells

"===============================================================================
" search
"===============================================================================
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
