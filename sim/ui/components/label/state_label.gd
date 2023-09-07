extends PanelContainer

@onready var label = $margin/hbox/label
var id = 0

func _ready():
	Signals.state_deleted.connect(_on_state_deleted)
	update_label()
	
func update_label():
	label.set_text(str('S', id))

func set_id(new_id):
	id = new_id

func get_id():
	return id

func _on_state_deleted(deleted_id):
	if deleted_id < id:
		id -= 1
		update_label()
	elif deleted_id == id:
		queue_free()


func _on_delete_button_pressed():
	Signals.node_deleted.emit(id)
