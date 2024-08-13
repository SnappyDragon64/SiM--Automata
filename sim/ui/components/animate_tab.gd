extends MarginContainer


var status = false # Is animation playing
var path = [] # Path of nodes to be followed during animation
var path_length = 0 # Lenght of the path
var current = 0 # Current node index
var test_string = '' # The string to be tested
var len_string = 0 # Length of the string to be tested

# Icons
var status_default = preload('res://asset/element/tool/refresh.svg')
var status_accepted = preload('res://asset/element/tool/accepted.svg')
var status_not_accepted = preload('res://asset/element/tool/not_accepted.svg')


# Input status
enum STATUS {
	NOT_TESTED, # Status when not in animation mode
	DEFAULT, # Default status in animation mode
	ACCEPTED, # Input string was accepted
	NOT_ACCEPTED, # Input string was not accepted
}


func _ready():
	Signals.animation_started.connect(_on_animation_started) # Signal connected to function
	Signals.animation_exited.connect(_on_animation_exited) # Signal connected to function
	Signals.clear.connect(_on_clear) # Signal connected to function


# Updates the playing status using the flag field
# Replay flag indicates whether the replay button should be visible instead of the play button
func set_playing(flag, replay=false):
	if path_length > 1: # Check to ensure animation has more than 1 step.
		if flag: # Animation is playing
			$Timer.start() # Start timer for animation steps
			
			# Update button visibilty
			%PlayButton.set_visible(false)
			%ReplayButton.set_visible(false)
			%PauseButton.set_visible(true)
		else: # Animation is not playing
			$Timer.stop() # Stop timer
			
			# Update button visibilty
			%PauseButton.set_visible(false)
			
			# Switch between play and replay buttons depending on the replay flag
			if replay: 
				%ReplayButton.set_visible(true)
				%PlayButton.set_visible(false)
			else:
				%ReplayButton.set_visible(false)
				%PlayButton.set_visible(true)


# Resets the input string to an empty string
func _on_clear():
	%Input.set_text('')


# Starts the animation
func _on_animation_started():
	# Update simulator status
	Signals.update_simulator_status.emit(Globals.SIM_STATUS.ANIM_START)
	
	# Update buttons
	for button in %ButtonContainer.get_children():
		button.set_disabled(false)
	
	# Toggle input
	%Input.set_visible(false)
	%RichTextLabel.set_visible(true)
	
	# Update animation status
	var input_text = %Input.get_text()
	var result = EvaluationEngine.evaluate([input_text])[0]
	status = result[0]
	path = result[1]
	
	# Handle empty input case
	if input_text.is_empty():
		test_string = %Input.get_placeholder()
		path.append(path.front())
	else:
		test_string = input_text
	
	# Update variables
	len_string = len(test_string)
	path_length = len(path)
	
	# Update animation status
	set_playing(true)
	update()


# Exits the animation
func _on_animation_exited():
	# Update simulator status
	Signals.update_simulator_status.emit(Globals.SIM_STATUS.ANIM_END)
	
	# Update buttons
	for button in %ButtonContainer.get_children():
		button.set_disabled(true)
	
	# Toggle input
	%Input.set_visible(true)
	%RichTextLabel.set_visible(false)
	
	# Update animation status
	set_playing(false)
	set_status(STATUS.NOT_TESTED)
	
	# Reset variable values
	status = false
	path = []
	path_length = 0
	current = 0
	test_string = ''
	len_string = 0


# Resets the animation to the start
func _on_start_button_pressed():
	current = 0
	set_playing(false)
	update()


# Moves to the previous animation step
func _on_previous_button_pressed():
	current = max(0, current - 1)
	set_playing(false)
	update()


# Plays the animation
func _on_play_button_pressed():
	if current < path_length - 1:
		set_playing(true)


# Pauses the animation
func _on_pause_button_pressed():
	set_playing(false)


# Replays the animation
func _on_replay_button_pressed():
	current = 0
	update()
	set_playing(true)


# Moves to the next animation step
func _on_next_button_pressed():
	current = min(current + 1, path_length - 1)
	set_playing(false)
	update()


# Skips to the end of the animation
func _on_end_button_pressed():
	current = path_length - 1
	set_playing(false)
	update()


# Updates the animation
func update():
	# Formats the input according to the characters tested
	var formatted_string = '[u]' + test_string.substr(0, current) + '[/u][i]' + test_string.substr(current, len_string - current + 1) + '[/i]'
	%RichTextLabel.set_text(formatted_string)
	
	var ctr = 0
	var state_to_status_map = {} # To track the status of each state
	
	# Initialize the state_to_status_map with each state in the path and set their status to DEFAULT
	while ctr < path_length:
		var state_id = path[ctr]
		state_to_status_map[state_id] = Globals.STATE_STATUS.DEFAULT
		ctr += 1
	
	# Mark the states preceeding the current state as VISITED
	ctr = 0
	while ctr < current:
		var state_id = path[ctr]
		state_to_status_map[state_id] = Globals.STATE_STATUS.VISITED
		ctr += 1
	
	# Update the status of the current state to CURRENT
	var current_state = path[current]
	state_to_status_map[current_state] = Globals.STATE_STATUS.CURRENT
	
	# Emit signals to update the states on the screen
	for state_id in state_to_status_map.keys():
		var state_status = state_to_status_map[state_id]
		Signals.set_state_status.emit(state_id, state_status)
	
	# Update animation status
	set_status(STATUS.DEFAULT)
	
	# Reset button status
	for button in %ButtonContainer.get_children():
		button.set_disabled(false)
	
	# Handle special cases
	if path_length == 1: # When the path only has one state
		for button in %ButtonContainer.get_children():
			button.set_disabled(true)
		
		set_status(STATUS.NOT_ACCEPTED)
	elif current == 0: # First step of animation
		%StartButton.set_disabled(true)
		%PreviousButton.set_disabled(true)
	elif current == path_length - 1: # Last step of animation
		%PlayButton.set_visible(false)
		%ReplayButton.set_visible(true)
		%NextButton.set_disabled(true)
		%EndButton.set_disabled(true)
		
		# Update animation status
		if status:
			set_status(STATUS.ACCEPTED)
		else:
			set_status(STATUS.NOT_ACCEPTED)


# Updates the status of the nodes
# Sets the icon and tooltip text
func set_status(new_status):
	var icon
	var text
	
	if new_status == STATUS.NOT_TESTED:
		icon = status_default
		text = 'Not Tested'
	elif new_status == STATUS.DEFAULT:
		icon = status_default
		text = 'In Progress'
	elif new_status == STATUS.ACCEPTED:
		icon = status_accepted
		text = 'Accepted'
	elif new_status == STATUS.NOT_ACCEPTED:
		icon = status_not_accepted
		text = 'Not Accepted'
	
	%Status.set_button_icon(icon)
	%Status.set_tooltip_text(text)


# Moves to the next node on timer timeout signal
func _on_timer_timeout():
	current = min(current + 1, path_length - 1)
	
	if current == path_length - 1:
		set_playing(false)
		
	update()
