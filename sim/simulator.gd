extends Control

@onready var interface = $interface_layer/interface

func _ready():
	DisplayServer.window_set_min_size(Vector2(640, 480))
	Signals.dark_mode.connect(_dark_mode)

func _dark_mode(flag):
	if flag:
		interface.set_theme(load('res://asset/theme/default.tres'))
	else:
		interface.set_theme(load('res://asset/theme/light.tres'))
