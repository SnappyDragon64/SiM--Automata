extends MarginContainer

var status = false
var path = []

func _ready():
	Signals.animation_started.connect(_on_animation_started)
	Signals.animation_exited.connect(_on_animation_exited)
	Signals.clear.connect(_on_clear)

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
	
	var label_text = %Input.get_placeholder() if len(input_text) == 0 else input_text
	%RichTextLabel.set_text(label_text)

func _on_animation_exited():
	for button in %ButtonContainer.get_children():
		button.set_disabled(true)
	
	%Input.set_visible(true)
	%RichTextLabel.set_visible(false)
	%PlayButton.set_visible(true)
	%PauseButton.set_visible(false)
	
	status = false
	path = []

func _on_start_button_pressed():
	pass

func _on_previous_button_pressed():
	pass

func _on_play_button_pressed():
	%PlayButton.set_visible(false)
	%PauseButton.set_visible(true)

func _on_pause_button_pressed():
	%PlayButton.set_visible(true)
	%PauseButton.set_visible(false)

func _on_next_button_pressed():
	pass

func _on_end_button_pressed():
	pass
