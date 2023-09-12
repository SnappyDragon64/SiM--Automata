extends MarginContainer

@onready var holder = $StatesPanel/StatesMargin/StatesScroll/ScrollMargin/VStates
var state_label_preload = preload('res://sim/ui/components/label/state_label.tscn')

func _ready():
	Signals.state_created.connect(_on_state_created)
	Signals.retrieve_states.connect(_on_retrieve_states)

func _on_state_created(id, node):
	var state_label = state_label_preload.instantiate()
	state_label.init(id, node)
	holder.add_child(state_label)

func _on_retrieve_states():
	Globals.STATES = holder.get_children()
