# Handles the functionality of the test strings in the sidebars

extends MarginContainer


# Test label holder
@onready var holder = %VTest

# Test label preload
var test_label_preload = preload('res://sim/ui/components/label/test_label.tscn')


func _ready():
	Signals.run.connect(_on_run) # Signal connected to function
	Signals.clear.connect(_on_clear) # Signal connected to function


func _on_run():
	if visible: # If this is the currently selected tab when the run button is pressed
		var strings = EvaluationEngine.get_test_strings() # Generates test strings
		_populate(strings) # Adds the generated test strings to the holder


func _populate(strings):
	# Deletes all previously generated test string labels
	for child in holder.get_children():
		child.queue_free()
	
	# Adds a test label for each test string
	for string in strings:
		var test_label = test_label_preload.instantiate()
		test_label.set_text(string)
		holder.add_child(test_label)
	
	# Updates the status of the simulator
	Signals.update_simulator_status.emit(Globals.SIM_STATUS.TEST, {count=len(strings)})


# Clears all test labels on clear
func _on_clear():
	for label in holder.get_children():
		label.queue_free()
