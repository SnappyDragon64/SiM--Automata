extends GridContainer

func _on_run_button_pressed():
	if EvaluationEngine.is_valid():
		%run_button.set_visible(false)
		%stop_button.set_visible(true)
		Signals.animation_started.emit()

func _on_stop_button_pressed():
	if EvaluationEngine.is_valid():
		%stop_button.set_visible(false)
		%run_button.set_visible(true)
		Signals.animation_exited.emit()
