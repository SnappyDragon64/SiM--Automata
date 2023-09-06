extends Node2D

func _ready():
	DisplayServer.window_set_min_size(Vector2(640, 480))
	Signals.dark_mode.connect(_dark_mode)

func _dark_mode(flag):
	$filter_layer.set_visible(not flag)
