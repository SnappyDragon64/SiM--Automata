# Used for updating the simulator status label

extends GridContainer


func _ready():
	Signals.animation_started.connect(_on_animation_started) # Signal connected to function
	Signals.animation_exited.connect(_on_animation_exited) # Signal connected to function
	Signals.update_simulator_status.connect(_on_update_simulator_status) # Signal connected to function


func _on_animation_started():
	# Update simulator mode label text
	%Label.set_text('Animation Mode')


func _on_animation_exited():
	# Update simulator mode label text
	%Label.set_text('Default Mode')


func _on_update_simulator_status(status, data={}):
	# Updates the status label and shows the time of the latest status update
	var time = Time.get_time_dict_from_system()
	var time_str = '%s:%s:%s' % [time['hour'], time['minute'], time['second']]
	var text
	
	if status == Globals.SIM_STATUS.RUN: # After running inputs on the constructed DFA
		text = 'Evaluated %s inputs' % data.get('count') # Displays the count of inputs evaluated
	elif status == Globals.SIM_STATUS.TEST: # Test string generation
		text = 'Generated %s test strings' % data.get('count') # Displays the count of test strings generated
	elif status == Globals.SIM_STATUS.ANIM_START: # On animation start
		text = 'Started animation mode'
	elif status == Globals.SIM_STATUS.ANIM_END: # On animation end
		text = 'Exited animation mode'
	
	text = text + ' at %s' % time_str
	%Status.set_text(text)
