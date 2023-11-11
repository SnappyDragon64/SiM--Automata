extends GridContainer

func _ready():
	Signals.animation_started.connect(_on_animation_started)
	Signals.animation_exited.connect(_on_animation_exited)

func _on_animation_started():
	%Label.set_text('Animation Mode')

func _on_animation_exited():
	%Label.set_text('Default Mode')
