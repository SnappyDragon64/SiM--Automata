# Handles theme, debug mode and popups

extends Control


@onready var interface = $interface_layer/interface
@onready var popup = $popup_layer/popup

# Preloaded themes
var default_theme = preload('res://asset/theme/default.tres')
var light_theme = preload('res://asset/theme/light.tres')
var debug_theme = preload('res://asset/theme/debug.tres')

# Debug keypress sequence
var debug_sequence = [4194320, 4194320, 4194322, 4194322, 4194319, 4194321, 4194319, 4194321, 66, 65]
var current_sequence = []


func _ready():
	# Sets minimum window size to 960x540
	DisplayServer.window_set_min_size(Vector2(960, 540))
	
	Signals.dark_mode.connect(_dark_mode)
	Signals.popup.connect(_popup)


# Updates the simulator theme
func set_simulator_theme(new_theme):
	interface.set_theme(new_theme)
	popup.set_theme(new_theme)


# Toggles dark mode
func _dark_mode(flag):
	if flag:
		set_simulator_theme(default_theme)
	else:
		set_simulator_theme(light_theme)


# Displays a popup with the specified text
func _popup(text):
	popup.popup(text)


# Used to enable debug mode
func _input(event):
	if event is InputEventKey and event.is_pressed():
		current_sequence.append(event.get_key_label())
		
		if len(current_sequence) > 10:
			current_sequence.pop_front()
		
		if current_sequence == debug_sequence:
			set_simulator_theme(debug_theme)
