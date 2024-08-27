# Handles the functionality of the individual transitions in the sidebars

extends PanelContainer

# State labels of the nodes associated with this transition label
@onready var from_state_label
@onready var to_state_label

# Text labels
# To indicate from and to states
@onready var from_label = $hbox/from_container/from_label
@onready var to_label = $hbox/to_container/to_label

# To indicate the types of the from and to states
@onready var from_prefix = $hbox/from_container/from_prefix
@onready var to_prefix = $hbox/to_container/to_prefix

# Input for the transition symbol
@onready var input = $hbox/transition_container/input


func _ready():
	Signals.update_transition_label.connect(_on_update_transition_label) # Signal connected to function
	Signals.delete_transition_label.connect(_on_delete_transition_label) # Signal connected to function
	Signals.animation_started.connect(_on_animation_started) # Signal connected to function
	Signals.animation_exited.connect(_on_animation_exited) # Signal connected to function
	update()


# Initializes the transition label by setting the associated from and to state labels
func init(from, to):
	from_state_label = EvaluationEngine.get_state_label_by_name(from)
	to_state_label = EvaluationEngine.get_state_label_by_name(to)


# Updates the text labels corresponding to the to and from states
func update():
	update_label(from_prefix, from_label, from_state_label)
	update_label(to_prefix, to_label, to_state_label)


# Updates the prefix_label and label after checking conditions on the label_node
func update_label(prefix_label, label, label_node):
	var state_node = label_node.node # State node associated with the state label
	
	var is_start = state_node.is_start
	var is_final = state_node.is_final
	var id = state_node.id
	
	var flag = true
	
	# Checks if the state is the start state and is also a final state
	flag = flag && set_label_text_conditionally(prefix_label, '->*', is_start && is_final)
	# Checks if the state is the start state
	flag = flag && set_label_text_conditionally(prefix_label, '->', is_start)
	# Checks if t he state is a final state
	flag = flag && set_label_text_conditionally(prefix_label, '*', is_final)
	
	# Sets the prefix label to an empty string if no conditions match
	if flag:
		prefix_label.set_text('')
	
	# Avoids updating text if the state label is marked for deletion
	if is_instance_valid(label_node):
		label.set_text(str('S', label_node.node.id))


# Checks a condition and updates the label text
# Returns the negation of the checked condition
func set_label_text_conditionally(label, text, flag):
	if flag:
		label.set_text(text)
	
	return not flag


# Returns the value of the transition symbol input box
func get_input():
	return input.get_text()


# Delete sthe transition when the delete button is pressed
func _on_delete_button_pressed():
	delete()


# Performs validity checks before updating the node
func _on_update_transition_label(state_name: String):
	if is_instance_valid(from_state_label) and is_instance_valid(to_state_label):
		if state_name == from_state_label.node_name or state_name == to_state_label.node_name:
			update()


# Performs validity checks before deleting the node
func _on_delete_transition_label(state_name: String):
	if is_instance_valid(from_state_label) and is_instance_valid(to_state_label):
		if state_name == from_state_label.node_name or state_name == to_state_label.node_name:
			delete()


# Handles deletion
func delete():
	Signals.actually_delete_transition_label.emit(self)


# Locks the input and buttons on entering animation mode
func _on_animation_started():
	%input.set_editable(false)
	%input.set_selecting_enabled(false)
	%input.set_focus_mode(Control.FOCUS_NONE)
	%delete_button.set_disabled(true)


# Unlocks the input and buttons on exiting animation mode
func _on_animation_exited():
	%input.set_editable(true)
	%input.set_selecting_enabled(true)
	%input.set_focus_mode(Control.FOCUS_CLICK)
	%delete_button.set_disabled(false)
