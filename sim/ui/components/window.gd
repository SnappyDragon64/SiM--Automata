extends GraphEdit


var state_preload := preload('res://sim/element/state.tscn')
var current_state = 0
var animation_active = false


func _ready():
	get_zoom_hbox().set_visible(false)
	Signals.grid.connect(_on_grid) # Signal connected to function
	Signals.redraw_transitions.connect(_on_redraw_transitions) # Signal connected to function
	Signals.state_label_deleted.connect(_on_state_label_deleted) # Signal connected to function
	Signals.animation_started.connect(_on_animation_started) # Signal connected to function
	Signals.animation_exited.connect(_on_animation_exited) # Signal connected to function


# Adds a transition from the from_node to the no_node
func _on_connection_request(from_node, from_port, to_node, to_port):
	if not animation_active: # Not allowed in animation mode
		connect_node(from_node, from_port, to_node, to_port)
		Signals.transition_created.emit(from_node, to_node) # Emits a signal to indicate a transition has been created


# Enables grid snapping
func _on_grid(flag):
	set_use_snap(flag)


# Redraws all transitions on the screen
func _on_redraw_transitions():
	# Removes all currently drawn transitions
	clear_connections()
	
	# Redraws all transitions using stored data
	for transition in get_tree().get_nodes_in_group('transition_label'):
		if is_instance_valid(transition.from_state_label) and is_instance_valid(transition.to_state_label):
			var to_state = transition.to_state_label.node_name
			var from_state = transition.from_state_label.node_name
			
			connect_node(from_state, 0, to_state, 0)


# Creates a new state at the clicked position on left mouse click when the cursor mode is CREATE
func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Globals.CURSOR_MODE == Globals.CURSOR_MODES.CREATE:
				var state_instance = state_preload.instantiate()
				state_instance.set_position_offset(event.get_position())
				state_instance.id = current_state
				current_state += 1
				add_child(state_instance)


# Decrements the state count when a state is deleted
func _on_state_label_deleted():
	current_state -= 1


# Disables mouse actions when animation mode is entered
func _on_animation_started():
	animation_active = true
	set_mouse_filter(MOUSE_FILTER_IGNORE)


# Enables mouse actions when animation mode is exited
func _on_animation_exited():
	animation_active = false
	set_mouse_filter(MOUSE_FILTER_STOP)
