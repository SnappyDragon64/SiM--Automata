extends MarginContainer


# Holds input labels
@onready var holder = %VInput

# Input label preload
var input_label_preload = preload('res://sim/ui/components/label/input_label.tscn')


func _ready():
	Signals.add_input.connect(_on_add_input) # Signal connected to function
	Signals.run.connect(_on_run) # Signal connected to function
	Signals.clear.connect(_on_clear) # Signal connected to function


# When another input is added, an input label is initialized and added to the holder
func _on_add_input():
	var input_label = input_label_preload.instantiate()
	holder.add_child(input_label)


func _on_run():
	if visible: # If this is the currently selected tab when the run button is pressed
		# Get all inputs from the input labels
		var input_labels = holder.get_children()
		var inputs = []
		
		for input_label in input_labels:
			inputs.append(input_label.get_input())
		
		# Evaluate all inputs
		var results = EvaluationEngine.evaluate(inputs)
		
		# Update the status of all labels
		var i = 0
		for result in results:
			input_labels[i].set_status(result[0])
			i += 1
		
		# Emit signal to updat the simulator status to run with a parameter count that indicates the number of inputs evaluated
		Signals.update_simulator_status.emit(Globals.SIM_STATUS.RUN, {count=i})


# Deletes all input labels on clear
func _on_clear():
	for label in holder.get_children():
		label.queue_free()
