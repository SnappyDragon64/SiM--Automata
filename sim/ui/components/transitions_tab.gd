extends MarginContainer

@onready var holder = $TransitionsPanel/TransitionsMargin/TransitionsScroll/ScrollMargin/VTransitions
var transition_label_preload = preload('res://sim/ui/components/label/transition_label.tscn')

func _ready():
	Signals.transition_created.connect(_on_transition_created)
	Signals.retrieve_transitions.connect(_on_retrieve_transitions)

func _on_transition_created(from_node, to_node):
	var transition_label = transition_label_preload.instantiate()
	transition_label.init(from_node, to_node)
	holder.add_child(transition_label)

func _on_retrieve_transitions():
	Globals.TRANSITIONS = holder.get_children()
