# Handles toolbar and button behaviour

extends PanelContainer


func _ready():
	# Unused option
	%option_button.add_item('DFA')
	
	Signals.animation_started.connect(_on_animation_started) # Signal connected to function
	Signals.animation_exited.connect(_on_animation_exited) # Signal connected to function


# Changes the cursor mode and locks dragging
func reset_and_set(cursor_mode):
	Globals.CURSOR_MODE = cursor_mode
	Signals.lock_dragging.emit(true)


# Changes cursor mode to SELECT and enables dragging
func _on_select_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.SELECT)
	Signals.lock_dragging.emit(false)


# Changes cursor mode to PAN
func _on_pan_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.PAN)


# Changes cursor mode to DELETE
func _on_create_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.CREATE)


# Changes cursor mode to LINK
func _on_link_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.LINK)


# Changes cursor mode to DELETE
func _on_delete_button_pressed():
	reset_and_set(Globals.CURSOR_MODES.DELETE)


# Toggles grid
func _on_grid_button_toggled(button_pressed):
	Signals.grid.emit(button_pressed)


# Toggles dark mode
func _on_dark_mode_button_toggled(button_pressed):
	Signals.dark_mode.emit(button_pressed)


# Clears the state transition diagram
func _on_clear_button_pressed():
	Signals.clear.emit()


# Resets cursor mode and disables tool bar buttons when animation mode is started
func _on_animation_started():
	reset_and_set(Globals.CURSOR_MODES.SELECT)
	Signals.lock_dragging.emit(false)
	%select_button.set_disabled(true)
	%create_button.set_disabled(true)
	%delete_button.set_disabled(true)
	%clear_button.set_disabled(true)
	%option_button.set_disabled(true)


# Enables tool bar buttons when animation mode is exited
func _on_animation_exited():
	%select_button.set_disabled(false)
	%create_button.set_disabled(false)
	%delete_button.set_disabled(false)
	%clear_button.set_disabled(false)
	%option_button.set_disabled(false)
