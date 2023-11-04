extends MarginContainer

var test_label_preload = preload('res://sim/ui/components/label/test_label.tscn')

func _ready():
	Signals.run.connect(_on_run)

func _on_run():
	if visible:
		var strings = EvaluationEngine.get_test_strings()
		_populate(strings)

func _populate(strings):
	for child in %VTest.get_children():
		child.queue_free()
	
	for string in strings:
		var test_label = test_label_preload.instantiate()
		test_label.set_text(string)
		%VTest.add_child(test_label)