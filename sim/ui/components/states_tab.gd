extends MarginContainer


# State label holder
@onready var holder = %VStates

# State label preload
var state_label_preload = preload('res://sim/ui/components/label/state_label.tscn')


func _ready():
	Signals.state_created.connect(_on_state_created) # Signal connected to function
	Signals.actually_delete_state_label.connect(_on_actually_delete_state_label) # Signal connected to function
	Signals.clear.connect(_on_clear) # Signal connected to function


# When a state is created, a new state label is initialized and added to the holder
func _on_state_created(node):
	var state_label = state_label_preload.instantiate()
	state_label.init(node)
	holder.add_child(state_label)


# Executed to finally delete the state label after all prerequisite tasks are performed
func _on_actually_delete_state_label(state_label):
	Signals.delete_transition_label.emit(state_label.node_name)
	state_label.free()
	update_state_ids()
	Signals.state_label_deleted.emit()


# Updates the ids of all states in the holder
# Used to renumber states when a state is deleted
func update_state_ids():
	var id = 0
	
	for state_label in holder.get_children():
		var node = state_label.node
		
		# Ignores any nodes marked for deletion
		if is_instance_valid(node):
			node.set_id(id)
		
		id += 1


# Deletes all states on clear
func _on_clear():
	for state_label in holder.get_children():
		state_label.delete()
