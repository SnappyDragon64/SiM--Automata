extends PanelContainer

func _on_select_button_pressed():
	Globals.CURSOR_MODE = Globals.CURSOR_MODES.SELECT

func _on_pan_button_pressed():
	Globals.CURSOR_MODE = Globals.CURSOR_MODES.PAN

func _on_create_button_pressed():
	Globals.CURSOR_MODE = Globals.CURSOR_MODES.CREATE

func _on_link_button_pressed():
	Globals.CURSOR_MODE = Globals.CURSOR_MODES.LINK

func _on_delete_button_pressed():
	Globals.CURSOR_MODE = Globals.CURSOR_MODES.DELETE

func _on_grid_button_toggled(button_pressed):
	Signals.grid.emit(button_pressed)
