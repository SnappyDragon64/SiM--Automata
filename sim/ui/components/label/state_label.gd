# Handles the functionality of the individual states in the sidebars

extends PanelContainer


# Text labels
@onready var pre_label = $hbox/label_hbox/pre_label
@onready var label = $hbox/label_hbox/label

# The node associated with this state label
var node = null
var node_name


func _ready():
	Signals.update_state_label.connect(_on_update_state_label) # Signal connected to function
	Signals.delete_state_label.connect(_on_delete_state_label) # Signal connected to function
	Signals.start_updated.connect(_on_start_updated) # Signal connected to function
	Signals.animation_started.connect(_on_animation_started) # Signal connected to function
	Signals.animation_exited.connect(_on_animation_exited) # Signal connected to function
	update() # Updates the state label


# Initializes the state label with a state node
func init(state_node):
	node = state_node
	node_name = state_node.name


# Updates the text labels
func update():
	label.set_text(str('S', node.id))
	
	# Sets the prefix according to the state node
	var prefix = ''
	if node.is_start and node.is_final:
		prefix = '->*'
	elif node.is_start:
		prefix = '->'
	elif node.is_final:
		prefix = '*'
	
	pre_label.set_text(prefix)
	
	# Emits signal on update
	Signals.update_transition_label.emit(node_name)


# Updates state label
func _on_update_state_label(state_name):
	if state_name == node_name:
		update()


# Initiates state label deletion process on signal
func _on_delete_state_label(state_name):
	if state_name == node_name:
		delete()


# Initiates state label deletion process on button press
func _on_delete_button_pressed():
	delete()


# Initiates state label deletion process
func delete():
	node.queue_free() # Marks the associated state node for deletion first
	await node.tree_exited # Waits until it is deleted
	Signals.actually_delete_state_label.emit(self) # Emits the signal to delete the state label


# Used to ensure there is only a single start state in the state transition diagram
func _on_make_start_button_toggled(button_pressed):
	node.set_start(button_pressed) # Sets this node as the start node
	
	if button_pressed:
		Signals.start_updated.emit(node_name) # Marks other nodes non-start nodes


# Sets this node as a final node
func _on_make_final_button_toggled(button_pressed):
	node.set_final(button_pressed)


# Used to update status of other nodes when the start node is changed
func _on_start_updated(state_name):
	if not state_name == node_name:
		%make_start_button.button_pressed = false
		node.set_start(false)


# Disables buttons on animation start
func _on_animation_started():
	%make_start_button.set_disabled(true)
	%make_final_button.set_disabled(true)
	%delete_button.set_disabled(true)


# Enables buttons on animation end
func _on_animation_exited():
	%make_start_button.set_disabled(false)
	%make_final_button.set_disabled(false)
	%delete_button.set_disabled(false)
