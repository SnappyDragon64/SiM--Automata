extends MarginContainer


# Transition label holder
@onready var holder = %VTransitions

# Transition label preload
var transition_label_preload = preload('res://sim/ui/components/label/transition_label.tscn')


func _ready():
	Signals.transition_created.connect(_on_transition_created) # Signal connected to function
	Signals.actually_delete_transition_label.connect(_on_actually_delete_transition_label) # Signal connected to function


# Initializes a transition label and adds it to the holder when a transition is created
func _on_transition_created(from_node, to_node):
	var transition_label = transition_label_preload.instantiate()
	transition_label.init(from_node, to_node)
	holder.add_child(transition_label)


# Handles transition label deletion
func _on_actually_delete_transition_label(transition_label):
	transition_label.queue_free() # Transition label is marked for deletion
	await transition_label.tree_exited # Waits until the transition label is deleted
	Signals.redraw_transitions.emit() # Redraws transitions
