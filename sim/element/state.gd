extends GraphNode

var id = 0

func _ready():
	update_title()
	Signals.state_created.emit(id)
	Signals.state_deleted.connect(_on_state_deleted)
	Signals.lock_dragging.connect(_lock_dragging)
	Signals.lock_slots.connect(_lock_slots)

func update_title():
	set_title(str('S', id))

func set_id(new_id):
	id = new_id

func get_id():
	return id

func _on_state_deleted(deleted_id):
	if deleted_id < id:
		id -= 1
		update_title()
	elif deleted_id == id:
		queue_free()

func _lock_dragging(flag):
	set_draggable(not flag)

func _lock_slots(flag):
	set_slot_enabled_left(0, not flag)
	set_slot_enabled_right(0, not flag)

func _on_node_selected():
	if Globals.CURSOR_MODE == Globals.CURSOR_MODES.DELETE:
		delete()

func delete():
	Signals.state_deleted.emit(id)
