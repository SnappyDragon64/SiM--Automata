extends PanelContainer

@onready var pre_label = $hbox/label_hbox/pre_label
@onready var label = $hbox/label_hbox/label
@onready var make_start_button = $hbox/button_hbox/make_start_button
var id = 0
var node = null
var is_start = false
var is_final = false

func _ready():
	Signals.state_deleted.connect(_on_state_deleted)
	Signals.state_is_start_updated.connect(_on_state_is_start_updated)
	Signals.state_is_final_updated.connect(_on_state_is_final_updated)
	update()

func init(state_id, state_node):
	id = state_id
	node = state_node

func update():
	label.set_text(str('S', id))
	
	var prefix = ''
	if is_start and is_final:
		prefix = '→*'
	elif is_start:
		prefix = '→'
	elif is_final:
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

func _on_state_is_start_updated(state_id, flag):
	if id == state_id:
		is_start = flag
		make_start_button.button_pressed = flag
		update()

func _on_state_is_final_updated(state_id, flag):
	if id == state_id:
		is_final = flag
		update()

func _on_delete_button_pressed():
	Signals.state_deleted.emit(id)

func _on_make_start_button_toggled(button_pressed):
	node.set_start(button_pressed)

func _on_make_final_button_toggled(button_pressed):
	node.set_final(button_pressed)
