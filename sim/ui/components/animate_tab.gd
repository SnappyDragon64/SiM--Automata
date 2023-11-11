extends MarginContainer

var status = false
var path = []
var path_length = 0
var current = 0

var status_default = preload('res://asset/element/tool/refresh.svg')
var status_accepted = preload('res://asset/element/tool/accepted.svg')
var status_not_accepted = preload('res://asset/element/tool/not_accepted.svg')

func _ready():
	Signals.animation_started.connect(_on_animation_started)
	Signals.animation_exited.connect(_on_animation_exited)
	Signals.clear.connect(_on_clear)

func set_playing(flag):
	if flag:
		$Timer.start()
		%PlayButton.set_visible(false)
		%PauseButton.set_visible(true)
	else:
		$Timer.stop()
		%PlayButton.set_visible(true)
		%PauseButton.set_visible(false)

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
	
	status = false
	path = []
	path_length = 0
	current = 0
	
	%Status.set_tooltip_text('Not Tested')

func _on_start_button_pressed():
	current = 0
	set_playing(false)
	update()

func _on_previous_button_pressed():
	current = max(0, current - 1)
	set_playing(false)
	update()

func _on_play_button_pressed():
	set_playing(true)

func _on_pause_button_pressed():
	set_playing(false)

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
	while ctr < path_length:
		var state_id = path[ctr]
		
		if ctr < current:
			Signals.set_state_status.emit(state_id, Globals.STATE_STATUS.VISITED)
		elif ctr == current:
			Signals.set_state_status.emit(state_id, Globals.STATE_STATUS.CURRENT)
		else:
			Signals.set_state_status.emit(state_id, Globals.STATE_STATUS.DEFAULT)
		
		ctr += 1
	
	%Status.set_tooltip_text('In Progress')
	for button in %ButtonContainer.get_children():
		button.set_disabled(false)
	
	%Status.set_tooltip_text('In Progress')
	if path_length == 1:
		for button in %ButtonContainer.get_children():
			button.set_disabled(true)
	elif current == 0:
		%StartButton.set_disabled(true)
		%PreviousButton.set_disabled(true)
	elif current == path_length - 1:
		%NextButton.set_disabled(true)
		%EndButton.set_disabled(true)

func _on_timer_timeout():
	current = current + 1
	update()
	
	if current == path_length - 1:
		set_playing(false)
