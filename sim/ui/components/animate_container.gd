extends GridContainer


# Executed when the run button is pressed
func _on_run_button_pressed():
	# Checks if the state transition diagram is valid
	if EvaluationEngine.is_valid():
		# Updates button status
		%run_button.set_visible(false)
		%stop_button.set_visible(true)
		
		# Starts animation mode
		Signals.animation_started.emit()


# Executed when the stop button is pressed
func _on_stop_button_pressed():
	# Checks if the state transition diagram is valid
	if EvaluationEngine.is_valid():
		# Updates button status
		%stop_button.set_visible(false)
		%run_button.set_visible(true)
		
		# Starts animation mode
		Signals.animation_exited.emit()
