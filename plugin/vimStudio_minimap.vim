if exists("g:vimStudio_minimap_init")
	if g:vimStudio_minimap_init == 1
		finish
	endif
endif

let g:vimStudio_minimap_init = 1

"-------------------------------------------------------------------------

let g:vimStudio_minimap#plugin_dir = expand("<sfile>:p:h:h")

let g:vimStudio_minimap#is_busy = 0
let g:vimStudio_minimap#minimap_bufname_status = 0

"-------------------------------------------------------------------------

function! vimStudio_minimap#set_width()
	if vimStudio#wnd#switch_to_wnd("vim-minimap") == 1
		execute "vertical" "resize" 20
	endif
endfunction

function! vimStudio_minimap#show()
	let result = 0
	
	if g:vimStudio_minimap#is_busy == 0
		let g:vimStudio_minimap#is_busy = 1
		let g:vimStudio_minimap#minimap_bufname_status = 1
		
		if vimStudio#wnd#switch_to_wnd("vim-minimap") == 0
			execute "Minimap"
			let result = 1
		else
			execute "MinimapUpdate"
			let result = 1
		endif
		
		let g:vimStudio_minimap#is_busy = 0
	endif
	
	return result
endfunction

function! vimStudio_minimap#hide()
	let result = 0
	
	if g:vimStudio#maskpanel#is_busy == 0
		if vimStudio#wnd#switch_to_wnd("vim-minimap") == 1
			let g:vimStudio_minimap#minimap_bufname_status = 0
			
			if vimStudio#wnd#switch_to_wnd("editor") == 1
				execute "MinimapClose"
			endif
		endif
	endif
	
	return result
endfunction

function! vimStudio_minimap#toogle()
	if g:vimStudio_minimap#minimap_bufname_status == 1
		return vimStudio_minimap#hide()
	endif
	
	return vimStudio_minimap#show()
endfunction

function! vimStudio_minimap#reload()
	let result = 0
	
	if g:vimStudio_minimap#minimap_bufname_status == 1
		let result = vimStudio#wnd#switch_to_wnd("vim-minimap")
		
		if result == 0
			let result = vimStudio_minimap#show()
		endif
		
		if result == 1
			call vimStudio_minimap#set_width()
		endif
	elseif vimStudio#wnd#switch_to_wnd("vim-minimap") == 1
		if vimStudio_minimap#hide() == 1
			let result = 2
		endif
	endif
	
	call vimStudio#wnd#switch_to_wnd("editor")
	return result
endfunction

"--------------------------------------------------------------------------

function! vimStudio_minimap#on_project_after_open()
	call vimStudio_minimap#show()
	call vimStudio_minimap#set_width()
	call vimStudio#wnd#switch_to_wnd("editor")
	
	return 1
endfunction

function! vimStudio_minimap#on_project_close()
	call vimStudio_minimap#hide()
	call vimStudio#wnd#switch_to_wnd("editor")
	
	return 1
endfunction

function! vimStudio_minimap#on_tab_changed()
	call vimStudio_minimap#reload()
	
	return 1
endfunction

"--------------------------------------------------------------------------

function! vimStudio_minimap#on_menu_item(menu_id)
	if a:menu_id == "minimap_toogle"
		call vimStudio_minimap#toogle()
		return 0
	endif
	
	return 1
endfunction

"--------------------------------------------------------------------------

map <silent> <F3> <esc>:call vimStudio_minimap#toogle()<CR>

"--------------------------------------------------------------------------

call vimStudio#integration#register_module("vimStudio_minimap")

call add(g:vimStudio#integration#context_menu_dir, g:vimStudio_minimap#plugin_dir . "/menu")
