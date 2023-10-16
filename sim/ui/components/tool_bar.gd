extends PanelContainer

func _ready():
	%option_button.add_item('DFA')

func reset_and_set(cursor_mode):
	Globals.CURSOR_MODE = cursor_mode
	Signals.lock_dragging.emit(true)
	Signals.lock_slots.emit(false)

func _on_select_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.SELECT)
	Signals.lock_dragging.emit(false)

func _on_pan_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.PAN)

func _on_create_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.CREATE)

func _on_link_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.LINK)
	#Signals.lock_slots.emit(false)

func _on_delete_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.DELETE)

func _on_grid_button_toggled(button_pressed):
	Signals.grid.emit(button_pressed)

func _on_dark_mode_button_toggled(button_pressed):
	Signals.dark_mode.emit(button_pressed)
