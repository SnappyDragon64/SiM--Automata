extends PanelContainer


@onready var input = $hbox/input
@onready var status = $hbox/status

# Icons
var status_accepted = preload('res://asset/element/tool/accepted.svg')
var status_not_accepted = preload('res://asset/element/tool/not_accepted.svg')


# Queues node for deletion when the delete button is pressed
func _on_delete_button_pressed():
	queue_free()


# Returns the text from the input box
func get_input():
	return input.get_text()


# Updates the status of the input label
func set_status(flag):
	if flag: # Status set to accepted if the value of flag is true
		status.set_button_icon(status_accepted)
		status.set_tooltip_text('Accepted')
	else: # Status set to not accepted if the value of flag is false
		status.set_button_icon(status_not_accepted)
		status.set_tooltip_text('Not Accepted')
