extends MarginContainer

@onready var holder = %VInput
var input_label_preload = preload('res://sim/ui/components/label/input_label.tscn')

func _ready():
	Signals.add_input.connect(_on_add_input)
	Signals.run.connect(_on_run)
	Signals.clear.connect(_on_clear)

func _on_add_input():
	var input_label = input_label_preload.instantiate()
	holder.add_child(input_label)

func _on_run():
	if visible:
		var input_labels = holder.get_children()
		var inputs = []
		
		for input_label in input_labels:
			inputs.append(input_label.get_input())
		
		var results = EvaluationEngine.evaluate(inputs)
		
		var i = 0
		for result in results:
			input_labels[i].set_status(result[0])
			i += 1

func _on_clear():
	for label in holder.get_children():
		label.queue_free()
