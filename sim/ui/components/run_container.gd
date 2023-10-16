extends GridContainer


func _on_add_input_button_pressed():
	Signals.add_input.emit()

func _on_run_button_pressed():
	if EvaluationEngine.is_valid():
		Signals.run.emit()

func _on_tab_changed(tab):
	$Input.set_visible(tab == 0)
	%add_input_button.set_visible(tab == 0)
	$Test.set_visible(tab == 1)
