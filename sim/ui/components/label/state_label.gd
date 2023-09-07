extends PanelContainer

@onready var pre_label = $margin/hbox/label_hbox/pre_label
@onready var label = $margin/hbox/label_hbox/label
var id = 0
var node = null
var state_type = Globals.STATE_TYPE.INTERMEDIATE

func _ready():
	Signals.state_deleted.connect(_on_state_deleted)
	Signals.state_type_updated.connect(_on_state_type_updated)
	update()

func init(state_id, state_node):
	id = state_id
	node = state_node

func update():
	label.set_text(str('S', id))
	
	var prefix = ''
	if state_type == Globals.STATE_TYPE.START:
		prefix = '→'
	elif state_type == Globals.STATE_TYPE.FINAL:
		prefix = '*'
	
	pre_label.set_text(prefix)

func set_id(new_id):
	id = new_id

func get_id():
	return id

func _on_state_deleted(deleted_id):
	if deleted_id < id:
		id -= 1
		update()
	elif deleted_id == id:
		queue_free()

func _on_state_type_updated(state_id, new_state_type):
	if id == state_id:
		state_type = new_state_type
		update()

func _on_delete_button_pressed():
	Signals.state_deleted.emit(id)

func _on_make_start_button_pressed():
	node.set_state_type(Globals.STATE_TYPE.START)

func _on_make_final_button_pressed():
	node.set_state_type(Globals.STATE_TYPE.FINAL)
