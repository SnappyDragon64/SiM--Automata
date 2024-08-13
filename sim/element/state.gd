extends GraphNode


var id = 0 # This state's id
var is_start = false # Is this state the start state
var is_final = false # Is this state a final state


func _ready():
	Signals.state_created.emit(self) # Signal connected to function
	Signals.lock_dragging.connect(_lock_dragging) # Signal connected to function
	Signals.animation_started.connect(_on_animation_started) # Signal connected to function
	Signals.animation_exited.connect(_on_animation_exited) # Signal connected to function
	Signals.set_state_status.connect(_on_set_state_status) # Signal connected to function
	update() # Updates the state title


# Updates the state title with the respective symbols if the state is the start state or is a final state
func update():
	var text = str('S', id)
	var offset = 6 - len(text) * 1.5 # Horizontal text offset
	var v_offset = 24 # Vertical text offset
	
	if is_start and is_final:
		text = str('->*', text)
		offset -= 20
	elif is_start:
		text = str('->', text)
		offset -= 13
	elif is_final:
		text = str('*', text)
		offset -= 7
	
	set_title(text)
	
	# Overrides theme values to set offset and v_offset
	add_theme_constant_override('title_h_offset', offset)
	add_theme_constant_override('title_offset', v_offset)
	Signals.update_state_label.emit(name)


# Marks the state as the start state and updates the state title
func set_start(flag):
	is_start = flag
	update()


# Marks the state as a final state and updates the state title
func set_final(flag):
	is_final = flag
	update()


# Sets the state id and updates the state title
func set_id(new_id):
	id = new_id
	update()


# Toggles dragging
func _lock_dragging(flag):
	set_draggable(not flag)


# When the start state is updated, if this state's id does not match, marks it as a non-start state
func _on_state_is_start_updated(state_id, flag):
	if state_id != id and flag:
		set_start(false)


# Deletes the node if it is selected when the cursor mode is DELETE
func _on_node_selected():
	if Globals.CURSOR_MODE == Globals.CURSOR_MODES.DELETE:
		Signals.delete_state_label.emit(name)


# Updates colors of the slots on theme change
func _on_theme_changed():
	var col = get_theme_color('slot_color')
	set_slot_color_left(0, col)
	set_slot_color_right(0, col)


# Unselects the node if it was selected when animation starts
func _on_animation_started():
	set_selected(false)


# Resets the status of the node to default when animations ends
func _on_animation_exited():
	set_status(Globals.STATE_STATUS.DEFAULT)


# Sets the theme variation of the node according to the status
# Used for animation
func set_status(status_id):
	if status_id == Globals.STATE_STATUS.DEFAULT:
		set_theme_type_variation('GraphNode')
	elif status_id == Globals.STATE_STATUS.VISITED:
		set_theme_type_variation('VisitedGraphNode')
	elif status_id == Globals.STATE_STATUS.CURRENT:
		set_theme_type_variation('CurrentGraphNode')


# Updates the status of the node
func _on_set_state_status(state_id, status_id):
	if state_id == id:
		set_status(status_id)
