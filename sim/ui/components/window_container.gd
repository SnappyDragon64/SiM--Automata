extends GridContainer

func _ready():
	Signals.animation_started.connect(_on_animation_started)
	Signals.animation_exited.connect(_on_animation_exited)
	Signals.update_simulator_status.connect(_on_update_simulator_status)

func _on_animation_started():
	%Label.set_text('Animation Mode')

func _on_animation_exited():
	%Label.set_text('Default Mode')

func _on_update_simulator_status(status, data={}):
	var time = Time.get_time_dict_from_system()
	var time_str = '%s:%s:%s' % [time['hour'], time['minute'], time['second']]
	var text
	
	if status == Globals.SIM_STATUS.RUN:
		text = 'Evaluated %s inputs' % data.get('count')
	elif status == Globals.SIM_STATUS.TEST:
		text = 'Generated %s test strings' % data.get('count')
	elif status == Globals.SIM_STATUS.ANIM_START:
		text = 'Started animation mode'
	elif status == Globals.SIM_STATUS.ANIM_END:
		text = 'Exited animation mode'
	
	text = text + ' at %s' % time_str
	%Status.set_text(text)
