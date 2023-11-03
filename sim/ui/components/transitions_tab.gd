extends MarginContainer

@onready var holder = %VTransitions
var transition_label_preload = preload('res://sim/ui/components/label/transition_label.tscn')

func _ready():
	Signals.transition_created.connect(_on_transition_created)
	Signals.actually_delete_transition_label.connect(_on_actually_delete_transition_label)

func _on_transition_created(from_node, to_node):
	var transition_label = transition_label_preload.instantiate()
	transition_label.init(from_node, to_node)
	holder.add_child(transition_label)

func _on_actually_delete_transition_label(transition_label):
	transition_label.queue_free()
	await transition_label.tree_exited
	Signals.redraw_transitions.emit()
