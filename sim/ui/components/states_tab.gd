extends MarginContainer

@onready var holder = $StatesPanel/StatesMargin/StatesScroll/ScrollMargin/VStates
var state_label_preload = preload('res://sim/ui/components/label/state_label.tscn')

func _ready():
	Signals.state_created.connect(_on_state_created)

func _on_state_created(id):
	var state_label = state_label_preload.instantiate()
	state_label.set_id(id)
	add_child(state_label)
