extends PanelContainer

func _ready():
	%option_button.add_item('DFA')

func reset_and_set(cursor_mode):
	Globals.CURSOR_MODE = cursor_mode
	Signals.lock_dragging.emit(true)

func _on_select_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.SELECT)
	Signals.lock_dragging.emit(false)

func _on_pan_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.PAN)

func _on_create_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.CREATE)

func _on_link_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.LINK)

func _on_delete_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.DELETE)

func _on_grid_button_toggled(button_pressed):
	Signals.grid.emit(button_pressed)

func _on_dark_mode_button_toggled(button_pressed):
	Signals.dark_mode.emit(button_pressed)

func _on_clear_button_pressed():
	for state_label in get_tree().get_nodes_in_group('state_label'):
		state_label.delete()
