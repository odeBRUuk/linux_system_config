" This vim configuration is a stripped-down, translated version of my Neovim
" configuration, which was taken from T.J. DeVries' kickstart.nvim, found at:
" -> www.github.com/nvim-lua/kickstart.nvim <-

" "¯\_(ツ)_/¯"

" For this rewrite, I lumped several sections together in folds. These folds are
" separated by 80-char long strings of comment chars (double quotes | ") and
" any autocommands for that section are blocked off in 40-char long strings of
" comment chars.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" GENERAL VIM SETUP {{{
" Set space as leader for commands (default is '\') key
let g:mapleader = " "
let g:localmapleader = " "

" Set folding method based on syntax language rules
let &foldmethod="syntax"

" When splitting horiz/vert, open the new window to the right/below the current
set splitright | set splitbelow

" Shows all modes other than 'Normal'
set showmode

" Remove auto-commenting of the next line following hitting <Enter> on a 
" commented line
set formatoptions-=cro

" add an extra shorthand to split window horizontally with 'h' instead of 's'
nmap <silent> <C-w>h <cmd>sp<CR>

" Decrese the write-to-disk time and timeout for keybinds
let &updatetime=250
let &timeoutlen=300

if has("xterm_clipboard")
    let &clipboard = (has("unnamedplus") ? "unnamedplus" : "unnamed")
endif

" Make status line visible always
let &laststatus=2

" Declare, define, and set the status line.
let &statusline = "%F\ %(\[%M%R%W\]%)%=c%c\ @\ l%l\ /\ %L\ (%P)"

" Turn on case-insensitive search
set ignorecase | set smartcase
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" TEXT/EDITOR FORMATTING {{{
" Ruler, so I can stay within 80 characters in a single line
if has("syntax")
    let &colorcolumn=80
endif

" Set line numbers/number of lines away from the cursor
set number | set relativenumber

" Set minimum number of lines above and below the cursor 
let &scrolloff=7 

" Highlight the current line
set cursorline

" Display special characters with a series of 
set list
set listchars=tab:<->,nbsp:_,trail:.
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" NAVIGATION {{{
" Disable arrow keys (only in normal mode, ofc)
nmap <left>  :echo "Use 'h' to move left :)"<CR>
nmap <down>  :echo "Use 'j' to move down :)"<CR>
nmap <up>    :echo "Use 'k' to move up :)"<CR>
nmap <right> :echo "Use 'l' to move up :)"<CR>

" Move between different Vim windows (left/down/up/right)
nmap <silent> <C-h>     <C-w><C-h>
nmap <silent> <C-left>  <C-w><C-h>

nmap <silent> <C-j>     <C-w><C-j>
nmap <silent> <C-down>  <C-w><C-j>

nmap <silent> <C-k>     <C-w><C-k>
nmap <silent> <C-up>    <C-w><C-k>

nmap <silent> <C-l>     <C-w><C-l>
nmap <silent> <C-right> <C-w><C-l>

" Allow easier escape from terminal mode
tmap <silent> <Esc><Esc> <C-\><C-n>

" Implement Home/End to start/end of line, like in Windows (force of habit)
imap <Home> <Esc>I
imap <End> <Esc>A
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" CUSTOM COMMANDS {{{
" Toggle indentation types if not properly set
nmap <silent> <Leader>ti <cmd>set expandtab!<CR>

" Toggle folding type; useful for when some files use markers instead of syntax
" file
" Due to generic name of 'ToggleFold', I added two underscores to attempt to 
" make the name more unique
function! ToggleFold__()
    let &foldmethod = (&foldmethod == "marker" ? "syntax" : "marker")
endfunction
nmap <silent> <Leader>tf <cmd>call ToggleFold__()<CR>

" Allow easier toggling of folds
nnoremap <silent> <Enter> za

""""""""""""""""""""""""""""""""""""""""
" TODO: CREATE CUSTOM COMMAND TO DO A FULL REPLACE, USING TCL SYNTAX (.C)
" TAKE WHOLE ARGUMENT. .C<DELIM>VAL.1<DELIM>VAL.2<DELIM><OPTS>
""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""
" A dictionary of file extensions (minus the '.') that special formatting should
" be applied to
const s:languageTable = {
    \ "sh":   1,
    \ "shl":  1,
    \ "js":   2,
    \ "ts":   2,
    \ "jsx":  2,
    \ "tsx":  2
\ }

" The commands to run for each file type listed above
const s:languageFormatCmds = {
    \ 0: [ 'expandtab',   'tabstop=4', 'shiftwidth=4' ],
    \ 1: [ 'noexpandtab', 'tabstop=4', 'shiftwidth=0' ],
    \ 2: [ 'expandtab',   'tabstop=2', 'shiftwidth=2' ]
\ }

" Get the file extension and attempt to get the list of commands
function! s:setFileFormatParams()
    let l:fileExt = expand("%:e")
    let l:langTableKey = get(s:languageTable, fileExt, 0)

    if !has_key(s:languageFormatCmds, l:langTableKey)
        return
    endif

    for cmd in get(s:languageFormatCmds, l:langTableKey)
        execute "set " . cmd
    endfor
endfunction

autocmd BufEnter * call s:setFileFormatParams()
""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""
" TODO: Create an autocommand that will comment out the lines of text that are
"       currently highlighted.
" nmap gcc => comment out a single line
" vmap gbc => comment out several lines (normally highlighted in visual mode)
""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""
" TODO: CREATE AN AUTOCOMPLETE THAT HAPPENS ON KEYPRESS. CAN USE 'TextChangedI'
" AND <C-N> (OR ADJACENT) TO DISPLAY THE LIST OF AUTOCOMPLETED WORDS.
" USE <C-j> TO GO DOWN, <C-k> TO GO UP 
" When typing, a popup box will display with a list of words to autocomplete.
" Hitting tab should confirm the choice
" <CTRL-{j/k}> should move down/up through the list
" hitting <Esc> will cancel the autocompletion
" If this starts to really bog down the system, then we can set it so that 
" '<Tab>' will summon an autocomplete list

function! s:displayAutocomplete()
endfunction

" I might need to manually draw the window with autocompletion every time the
" keys are pressed and when the cursor moves.
" Alternatively, there are some scripts I could reference for inspriation (or
" outright steal the code from).
" But, I've done most of my work at Adelphi without autocomplete, so it isn't
" needed.

autocmd TextChangedI * call s:displayAutocomplete()
""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""
" TODO: CREATE A LIVE SUBSTITUTION FEATURE
""""""""""""""""""""""""""""""""""""""""
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" HIGHLIGHTING {{{
""""""""""""""""""""""""""""""""""""""""
function! s:highlightYankedText()
    " set the background to the search/highlight color
    " set_timer(50, clear highlight here
endfunction

autocmd TextYankPost * call s:highlightYankedText()
""""""""""""""""""""""""""""""""""""""""

" Highlight search match options, and press "Escape" to cancel
set hlsearch | nmap <silent> <Esc> :nohlsearch<CR>
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" VIM CONSOLE COLORING {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The following was taken from 'thedenisnikulin'/vim-cyberpunk; considering I do
" not have a need for a whole package manager in regular Vim, I decided to copy
" and paste the contents of my favorite colorscheme in my new Vim config. That
" way, I'll never lose it :)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set GUI colorschemes :)
set termguicolors

highlight clear

if exists("syntax_on")
    syntax reset
endif

" this can be changed to 'transparant' or something to allow using the 
" terminal's background.
set background=dark
let g:colors_name = "cyberpunk"

function! HighlightFor(group, ...)
    execute "hi " . a:group
        \ . " guifg=".a:1
        \ . " guibg=".a:2
        \ . " gui=".a:3
endfunction

" general 
call HighlightFor("Normal",      "#FF0055", "#120b10", "NONE") " old bg: #1a1018
call HighlightFor("Visual",      "NONE",    "#563466", "NONE")
call HighlightFor("ColorColumn", "NONE",    "#182333", "NONE")
call HighlightFor("LineNr",      "#FF0055", "NONE",    "NONE")
call HighlightFor("SignColumn",  "#00FFC8", "NONE",    "NONE")

call HighlightFor("DiffAdd",    "NONE", "NONE",    "NONE")
call HighlightFor("DiffDelete", "NONE", "#ff1745", "NONE" )
call HighlightFor("DiffText",   "NONE", "#00ff84", "NONE")
call HighlightFor("DiffChange", "NONE", "NONE",    "NONE")

call HighlightFor("VertSplit", "#FF0055", "#101116", "NONE")

call HighlightFor("IncSearch",  "NONE", "#283593", "NONE")
call HighlightFor("Search",     "NONE", "#283593", "NONE")
call HighlightFor("Substitute", "NONE", "#283593", "NONE")

call HighlightFor("MatchParen", "#FF0055", "#00FFC8", "NONE")
call HighlightFor("NonText",    "#2B3E5A", "NONE", "NONE")
call HighlightFor("Whitespace", "#2B3E5A", "NONE", "NONE")

call HighlightFor("WildMenu",  "#00FFC8", "NONE", "bold")
call HighlightFor("Directory", "#00FFC8", "NONE", "NONE")
call HighlightFor("Title",     "#c592ff", "NONE", "NONE")

" Cursor {{{
call HighlightFor("Cursor",       "#00FFC8", "NONE",    "NONE")
call HighlightFor("CursorLineNr", "#140007", "#00FFC8", "NONE")
call HighlightFor("CursorLine", "#1c171f", "NONE", "NONE")

call HighlightFor("CursorColumn", "NONE",    "NONE",    "NONE")
" }}}

" Code {{{
" The following groups are not builtin but are defined commonly in syntax files
call HighlightFor("Comment",   "#6766b3", "NONE", "NONE")
call HighlightFor("String",    "#76C1FF", "NONE", "NONE")
call HighlightFor("Number",    "#fffc58",  "NONE", "NONE")
call HighlightFor("Float",     "#fffc58",  "NONE", "NONE")
call HighlightFor("Boolean",   "#fffc58",  "NONE", "NONE")
call HighlightFor("Character", "#fffc58",  "NONE", "NONE")

call HighlightFor("Conditional",  "#76C1FF", "NONE", "NONE")
call HighlightFor("Repeat",       "#76C1FF", "NONE", "NONE")
call HighlightFor("Label",        "#76C1FF", "NONE", "NONE")
call HighlightFor("Exception",    "#76C1FF", "NONE", "NONE")
call HighlightFor("Operator",     "#76C1FF", "NONE", "NONE")
call HighlightFor("Keyword",      "#76C1FF", "NONE", "NONE")
call HighlightFor("StorageClass", "#d57bff", "NONE", "NONE")
call HighlightFor("Statement",    "#76C1FF", "NONE", "NONE")

call HighlightFor("Function",   "#d57bff", "NONE", "NONE")
call HighlightFor("Identifier", "#EEFFFF", "NONE", "NONE")

call HighlightFor("PreProc", "#00FF9C", "NONE", "NONE")

call HighlightFor("Type",      "#00FF9C", "NONE", "NONE")
call HighlightFor("Structure", "#00FF9C", "NONE", "NONE")
call HighlightFor("Typedef",   "#00FF9C", "NONE", "NONE")

call HighlightFor("Underlined", "NONE",    "NONE",    "NONE")
call HighlightFor("Todo",       "#00FF9C", "#372963", "italic")
call HighlightFor("Error",      "#ff3270", "NONE",   "undercurl")
call HighlightFor("WarningMsg", "#009550", "NONE",   "NONE")
call HighlightFor("Special",    "#00FF9C", "NONE",   "italic")
call HighlightFor("Tag",        "#00FF9C", "NONE",    "undercurl")
" }}}

" Pmenu {{{
call HighlightFor("Pmenu",      "#ff0055", "#140007", "NONE")
call HighlightFor("PmenuSel",   "#140007", "#ff0055", "NONE")
call HighlightFor("PmenuSbar",  "NONE",    "#ff0055", "NONE")
call HighlightFor("PmenuThumb", "NONE",    "NONE",    "NONE")
" }}}

" Status line {{{
call HighlightFor("StatusLine",   "#ff0055", "#1d000a", "bold")
call HighlightFor("StatusLineNC", "#ff0055", "#000000", "NONE")
" }}}

" Tab pages {{{
call HighlightFor("TabLine",     "#FF4081", "NONE", "NONE")
call HighlightFor("TabLineFill", "NONE",    "NONE", "NONE")
call HighlightFor("TabLineSel",  "#FF4081", "NONE", "bold")
" }}}

" Folds {{{
call HighlightFor("Folded",     "#00FFC8", "NONE", "italic")
call HighlightFor("FoldColumn", "#00FFC8", "NONE", "NONE")
" }}}

" This was code I added to refine the colorscheme.
" Originally called: :colorscheme "cyberpunk"
highlight Special gui=NONE
highlight CursorLine guibg=#1c171f guifg=NONE gui=NONE cterm=NONE
highlight Cursor gui=none guifg=#2b3e5a guibg=#00ffc8
highlight IncSearch cterm=reverse guibg=#13b894

highlight CursorLineNr cterm=NONE

" Set all characters in positions > 80 to be highlighted in red; if colorcolumn
" is not available, this will still be used.
highlight OverLength ctermbg=darkred ctermfg=white guibg=#ff3270 guifg=bg
match OverLength /\%>80v.\+/

" }}} COLORS
