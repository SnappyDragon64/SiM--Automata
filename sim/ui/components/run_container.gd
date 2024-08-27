# Handles the functioning of the run button to test inputs or generate test strings

extends GridContainer


# Emits signal to add another input label
func _on_add_input_button_pressed():
	Signals.add_input.emit()


# Validates the constructed DFA before emitting the run signal to evaluate inputs
func _on_run_button_pressed():
	if EvaluationEngine.is_valid():
		Signals.run.emit()


# Handles tab and button visibility
func _on_tab_changed(tab):
	$Input.set_visible(tab == 0)
	$Test.set_visible(tab == 1)
	
	%add_input_button.set_visible(tab == 0)
