extends Control

@onready var interface = $interface_layer/interface

var default_theme = preload('res://asset/theme/default.tres')
var light_theme = preload('res://asset/theme/light.tres')
var debug_theme = preload('res://asset/theme/debug.tres')

var debug_sequence = [4194320, 4194320, 4194322, 4194322, 4194319, 4194321, 4194319, 4194321, 66, 65]
var current_sequence = []

func _ready():
	DisplayServer.window_set_min_size(Vector2(640, 480))
	Signals.dark_mode.connect(_dark_mode)

func _dark_mode(flag):
	if flag:
		interface.set_theme(default_theme)
	else:
		interface.set_theme(light_theme)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		current_sequence.append(event.get_key_label())
		
		if len(current_sequence) > 10:
			current_sequence.pop_front()
		
		if current_sequence == debug_sequence:
			interface.set_theme(debug_theme)
