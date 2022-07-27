" Basic Settings
let g:netrw_banner = 0
let g:netrw_liststyle = 0
let g:netrw_keepdir = 0
let g:netrw_list_hide='^./,^../'
let g:netrw_sizestyle = "H"
let g:netrw_browse_split = 0
let g:netrw_alto = 0
let g:netrw_altv = 1
let g:netrw_preview=1
if has('unix')
   let g:netrw_browsex_viewer = "xdg-open"
endif
let g:Netrw_UserMaps = [
         \['K', 'MarkFileUp'],
         \['J', 'MarkFileDown'],
         \['i', 'NetrwListStyleVerbose'],
         \['s', 'NetrwSortByVerbose'],
         \['y', 'NetrwSetPasteOpAsCopy'],
         \['x', 'NetrwSetPasteOpAsMove'],
         \['C', 'NetrwResetPasteOperation'],
         \['p', 'NetrwClipboardPaste'],
         \['cl', 'NetrwCopyLocation'],
         \['mls', 'NetrwCreateSymLink'],
         \['mlr', 'NetrwCreateRelLink'],
         \['mlh', 'NetrwCreateHardLink'],
         \['P', 'NetrwTogglePreviewMode'],
         \['Z', 'NetrwZluaTo']
         \] " relevant functions are decalred below

hi! link netrwMarkFile WildMenu
hi! netrwCopyMark  guibg=Orange guifg=black
hi! netrwMoveMark  guibg=Red guifg=black

" defining g:netrw_pasteaction for future use (in ftplugin)
let g:netrw_pasteaction = ""

"  Netrw Function wrappers
"
"  Simply nmapping to netrw#Call('NetrwMarkFile', netrw#Call('NetrwGetWord')
"  doesn't work, likely due to nested netrw#Call, I don't really know
"  TODO consider moving into autoload?
function! NetrwMarkFileBinding()
   let l:filespec = netrw#Call('NetrwGetWord')
   call netrw#Call('NetrwMarkFile', 1, l:filespec)
endfunction

function! MarkFileUp( isLocal )
   call NetrwMarkFileBinding()
   normal k
   return ""
endfunction

function! MarkFileDown( isLocal )
   call NetrwMarkFileBinding()
   normal j
   return ""
endfunction

" --------------- "
"  tell me what's happening
"  -------------- "
function! NetrwListStyleVerbose(isLocal)
   if !a:isLocal
      echoerr 'not local session, aborting...'
      return
   endif
   call netrw#Call("NetrwListStyle", 1)
   echo get({0: "simple", 1: "info", 2: "compact", 3: "tree"}, w:netrw_liststyle)
   return ""
endfunction

function! NetrwSortByVerbose(isLocal)
   if !a:isLocal
      echoerr 'not local session, aborting...'
      return
   endif
   call netrw#Call("NetrwSortStyle", 1)
   echo "sort by: ".g:netrw_sort_by
   return ""
endfunction

" ---------------- "
"  Copy/paste that makes sense
"  --------------- "
function! NetrwClipboardPaste(isLocal)
   if !a:isLocal
      echoerr 'not local session, aborting...'
      return ""
   endif
   let marked=netrw#Expose("netrwmarkfilelist")
   let dest=getcwd()
   if type(marked) != type([]) " || len(marked) == 0
      echoerr "No files selected"
      return
   endif
   if g:netrw_pasteaction == "copy"
      " hack: on unix uses '-R' option offered by g:netrw_localcopydircmdopt
      " -i on unix 'interactive': ask before overwrite
      let l:baseCmd = g:netrw_localcopycmd." ".g:netrw_localcopydircmdopt
   elseif g:netrw_pasteaction == "move"
      let l:baseCmd = g:netrw_localmovecmd
   else
      echoerr "No paste action selected"
      return ""
   endif

   call netrw#Modify("netrwmarkfilelist", [])
   call netrw#Modify('netrwmarkfilemtch_{bufnr("%")}',"")
   call NetrwResetPasteOperation(a:isLocal)
   
   for file in marked
      call system(baseCmd.' "'. file.'" "'.dest.'"')
   endfor

   return "refresh"
endfunction

" Set/unset a paste action through g:netrw_pasteaction and select a file under
" the cursor if necessary
function! NetrwResetPasteOperation(isLocal)
   let g:netrw_pasteaction = ""
   hi! link netrwMarkFile WildMenu
   return ""
endfunction

function! NetrwSetPasteOpAsMove(isLocal)
   let marked=netrw#Expose("netrwmarkfilelist")
   if type(marked) != type([]) || len(marked) == 0
      call NetrwMarkFileBinding()
   endif
   let g:netrw_pasteaction = "move"
   hi! link netrwMarkFile netrwMoveMark
   return ""
endfunction

function! NetrwSetPasteOpAsCopy(isLocal)
   let marked=netrw#Expose("netrwmarkfilelist")
   if type(marked) != type([]) || len(marked) == 0
      call NetrwMarkFileBinding()
   endif
   let g:netrw_pasteaction = "copy"
   hi! link netrwMarkFile netrwCopyMark
   return ""
endfunction

"  --------------- "
"  soft and hard links (unix only)
"  --------------- "
function! NetrwCreateLink(options)
   let marked=netrw#Expose("netrwmarkfilelist")
   if has("unix")
      let baseCmd="ln "
   else
      echomsg "Links are not supported on your system"
      return
   endif

   call netrw#Modify("netrwmarkfilelist", [])
   call netrw#Modify('netrwmarkfilemtch_{bufnr("%")}',"")
   call NetrwResetPasteOperation(1)

   for file in marked
      call system(baseCmd.a:options." '".file."' '".getcwd()."'")
   endfor
endfunction

function! NetrwCreateSymLink(isLocal)
   call NetrwCreateLink('-s')
   return "refresh"
endfunction

function! NetrwCreateRelLink(isLocal)
   call NetrwCreateLink('-sr')
   return "refresh"
endfunction

function! NetrwCreateHardLink(isLocal)
   call NetrwCreateLink('-h')
   return "refresh"
endfunction

" Copy File location
function! NetrwCopyLocation(isLocal)
   let @"=getcwd()."/".netrw#Call('NetrwGetWord')
   echo "copied ".@"." to clipboard"
   return ""
endfunction

"  --------------- "
"  Preview mode
"  --------------- "
function! NetrwPreviewFile()
   let file = netrw#Call("NetrwGetWord")
   if !isdirectory(file)
      call netrw#Call("NetrwPreview", netrw#Call("NetrwBrowseChgDir", 1, file,1))
   endif
endfunction

function! NetrwTogglePreviewMode(isLocal)
   if !exists('#NetrwPreviewMode#CursorMoved')
      augroup NetrwPreviewMode
         autocmd!
         autocmd CursorMoved * if &ft == 'netrw' | call NetrwPreviewFile()
      augroup END
      echom "Preview mode: On"
      call NetrwPreviewFile()
   else
      augroup NetrwPreviewMode
         autocmd!
      augroup END
      echom "Preview mode: Off"
      pclose
   endif
endfunction

" ------------------ "
" z.lua integration
" -------------------"
function! NetrwZluaTo(isLocal)
   call inputsave()
   let pattern = input('zlua: where to? ')
   call inputrestore()
   if pattern == ""
      return ""
   endif

   " z.lua must be in ~/.config/nvim/lua/ or in any of the vim
   " <runtimepath>/lua/ directories
   execute "Explore" luaeval('require("z").z_cd({_A.pattern})', {'pattern' : pattern})
endfunction
