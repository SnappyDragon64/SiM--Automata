extends GraphEdit

var state_preload := preload('res://sim/element/state.tscn')

func _ready():
	get_zoom_hbox().set_visible(false)
	Signals.grid.connect(_on_grid)

func _on_resized():
	Signals.window_size_updated.emit(get_global_rect())

func _on_connection_request(from_node, from_port, to_node, to_port):
	connect_node(from_node, from_port, to_node, to_port)

func _on_grid(flag):
	set_use_snap(flag)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Globals.CURSOR_MODE == Globals.CURSOR_MODES.CREATE:
				var state_instance = state_preload.instantiate()
				state_instance.set_position_offset(event.get_position())
				add_child(state_instance)
