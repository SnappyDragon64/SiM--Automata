extends PanelContainer

@onready var input = $hbox/input
@onready var status = $hbox/status

var status_accepted = preload('res://asset/element/tool/accepted.svg')
var status_not_accepted = preload('res://asset/element/tool/not_accepted.svg')

func _on_delete_button_pressed():
	queue_free()

func get_input():
	return input.get_text()

func set_status(flag):
	if flag:
		status.set_button_icon(status_accepted)
		status.set_tooltip_text('Accepted')
	else:
		status.set_button_icon(status_not_accepted)
		status.set_tooltip_text('Not Accepted')
