extends MarginContainer

@onready var holder = %VStates
var state_label_preload = preload('res://sim/ui/components/label/state_label.tscn')

func _ready():
	Signals.state_created.connect(_on_state_created)
	Signals.actually_delete_state_label.connect(_on_actually_delete_state_label)

func _on_state_created(node):
	var state_label = state_label_preload.instantiate()
	state_label.init(node)
	holder.add_child(state_label)

func _on_actually_delete_state_label(state_label):
	Signals.delete_transition_label.emit(state_label.node_name)
	state_label.free()
	update_state_ids()

func update_state_ids():
	var id = 0
	
	for state_label in holder.get_children():
		var node = state_label.node
		
		if is_instance_valid(node):
			node.set_id(id)
		
		id += 1
