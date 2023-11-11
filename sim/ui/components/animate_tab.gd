extends MarginContainer

var status = false
var path = []
var path_length = 0
var current = 0

var status_default = preload('res://asset/element/tool/refresh.svg')
var status_accepted = preload('res://asset/element/tool/accepted.svg')
var status_not_accepted = preload('res://asset/element/tool/not_accepted.svg')

enum STATUS {
	NOT_TESTED,
	DEFAULT,
	ACCEPTED,
	NOT_ACCEPTED,
}

func _ready():
	Signals.animation_started.connect(_on_animation_started)
	Signals.animation_exited.connect(_on_animation_exited)
	Signals.clear.connect(_on_clear)

func set_playing(flag, replay=false):
	if flag:
		$Timer.start()
		%PlayButton.set_visible(false)
		%ReplayButton.set_visible(false)
		%PauseButton.set_visible(true)
	else:
		$Timer.stop()
		%PauseButton.set_visible(false)
		
		if replay:
			%ReplayButton.set_visible(true)
			%PlayButton.set_visible(false)
		else:
			%ReplayButton.set_visible(false)
			%PlayButton.set_visible(true)

func _on_clear():
	%Input.set_text('')

func _on_animation_started():
	for button in %ButtonContainer.get_children():
		button.set_disabled(false)
	
	%Input.set_visible(false)
	%RichTextLabel.set_visible(true)
	
	var input_text = %Input.get_text()
	var result = EvaluationEngine.evaluate([input_text])[0]
	status = result[0]
	path = result[1]
	path_length = len(path)
	
	var label_text = %Input.get_placeholder() if len(input_text) == 0 else input_text
	%RichTextLabel.set_text(label_text)
	
	update()

func _on_animation_exited():
	for button in %ButtonContainer.get_children():
		button.set_disabled(true)
	
	%Input.set_visible(true)
	%RichTextLabel.set_visible(false)
	set_playing(false)
	set_status(STATUS.NOT_TESTED)
	
	status = false
	path = []
	path_length = 0
	current = 0

func _on_start_button_pressed():
	current = 0
	set_playing(false)
	update()

func _on_previous_button_pressed():
	current = max(0, current - 1)
	set_playing(false)
	update()

func _on_play_button_pressed():
	if current < path_length - 1:
		set_playing(true)

func _on_pause_button_pressed():
	set_playing(false)

func _on_replay_button_pressed():
	current = 0
	update()
	set_playing(true)

func _on_next_button_pressed():
	current = min(current + 1, path_length - 1)
	set_playing(false)
	update()

func _on_end_button_pressed():
	current = path_length - 1
	set_playing(false)
	update()

func update():
	var ctr = 0
	var state_to_status_map = {}
	
	while ctr < path_length:
		var state_id = path[ctr]
		state_to_status_map[state_id] = Globals.STATE_STATUS.DEFAULT
		ctr += 1
	
	ctr = 0
	while ctr < current:
		var state_id = path[ctr]
		state_to_status_map[state_id] = Globals.STATE_STATUS.VISITED
		ctr += 1
	
	var current_state = path[current]
	state_to_status_map[current_state] = Globals.STATE_STATUS.CURRENT
	
	for state_id in state_to_status_map.keys():
		var state_status = state_to_status_map[state_id]
		Signals.set_state_status.emit(state_id, state_status)
	
	set_status(STATUS.DEFAULT)
	for button in %ButtonContainer.get_children():
		button.set_disabled(false)
	
	if path_length == 1:
		for button in %ButtonContainer.get_children():
			button.set_disabled(true)
	elif current == 0:
		%StartButton.set_disabled(true)
		%PreviousButton.set_disabled(true)
	elif current == path_length - 1:
		%PlayButton.set_visible(false)
		%ReplayButton.set_visible(true)
		%NextButton.set_disabled(true)
		%EndButton.set_disabled(true)
		
		if status:
			set_status(STATUS.ACCEPTED)
		else:
			set_status(STATUS.NOT_ACCEPTED)

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

func _on_timer_timeout():
	if current + 1 == path_length - 1:
		set_playing(false)
	
	current = current + 1
	update()
