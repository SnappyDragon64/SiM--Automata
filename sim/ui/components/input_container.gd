extends GridContainer

@onready var holder = $Input/InputPanel/InputMargin/InputScroll/ScrollMargin/VInput
var input_label_preload = preload('res://sim/ui/components/label/input_label.tscn')

func _on_add_input_button_pressed():
	var input_label = input_label_preload.instantiate()
	holder.add_child(input_label)

func _on_run_button_pressed():
	var input_labels = holder.get_children()
	var inputs = []
	
	for input_label in input_labels:
		inputs.append(input_label.get_input())
	
	var results = EvaluationEngine.evaluate(inputs)
	
	var i = 0
	for result in results:
		input_labels[i].set_status(result)
		i += 1
