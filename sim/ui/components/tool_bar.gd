extends PanelContainer

func _ready():
	%option_button.add_item('DFA')
	Signals.animation_started.connect(_on_animation_started)
	Signals.animation_exited.connect(_on_animation_exited)

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
	Signals.clear.emit()

func _on_animation_started():
	reset_and_set(Globals.CURSOR_MODES.SELECT)
	Signals.lock_dragging.emit(false)
	%select_button.set_disabled(true)
	%create_button.set_disabled(true)
	%delete_button.set_disabled(true)
	%clear_button.set_disabled(true)
	%option_button.set_disabled(true)

func _on_animation_exited():
	%select_button.set_disabled(false)
	%create_button.set_disabled(false)
	%delete_button.set_disabled(false)
	%clear_button.set_disabled(false)
	%option_button.set_disabled(false)
