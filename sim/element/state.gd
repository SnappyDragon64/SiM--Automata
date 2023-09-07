extends GraphNode

enum STATE_TYPE {START, INTERMEDIATE, FINAL}
var id = 0
var state_type = STATE_TYPE.INTERMEDIATE

func _ready():
	update()
	add_to_map()
	Signals.state_created.emit(id)
	Signals.state_deleted.connect(_on_state_deleted)
	Signals.lock_dragging.connect(_lock_dragging)
	Signals.lock_slots.connect(_lock_slots)

func update():
	set_title(str('S', id))

func add_to_map():
	Globals.STATE_NODE_MAP.append(self)

func set_id(new_id):
	id = new_id

func get_id():
	return id

func _on_state_deleted(deleted_id):
	if deleted_id < id:
		id -= 1
		update()
	elif deleted_id == id:
		Globals.STATE_NODE_MAP.erase(self)
		queue_free()

func _lock_dragging(flag):
	set_draggable(not flag)

func _lock_slots(flag):
	set_slot_enabled_left(1, not flag)
	set_slot_enabled_right(2, not flag)

func _on_node_selected():
	if Globals.CURSOR_MODE == Globals.CURSOR_MODES.DELETE:
		delete()

func delete():
	Signals.state_deleted.emit(id)
