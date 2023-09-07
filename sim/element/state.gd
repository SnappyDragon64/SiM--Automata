extends GraphNode

var id = 0
var state_type = Globals.STATE_TYPE.INTERMEDIATE

func _ready():
	add_to_map()
	Signals.state_created.emit(id, self)
	Signals.state_deleted.connect(_on_state_deleted)
	Signals.lock_dragging.connect(_lock_dragging)
	Signals.lock_slots.connect(_lock_slots)
	update()

func update():
	var text = str('S', id)
	var offset = 6 - len(text) * 1.5
	var v_offset = 24
	
	if state_type == Globals.STATE_TYPE.START:
		text = str('→', text)
		offset -= 14
		v_offset += 1
	elif state_type == Globals.STATE_TYPE.FINAL:
		text = str('*', text)
		offset -= 7
	
	set_title(text)
	add_theme_constant_override('title_h_offset', offset)
	add_theme_constant_override('title_offset', v_offset)

func set_state_type(new_state_type):
	state_type = new_state_type
	Signals.state_type_updated.emit(id, state_type)
	update()

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
	set_slot_enabled_left(0, not flag)
	set_slot_enabled_right(0, not flag)

func _on_node_selected():
	if Globals.CURSOR_MODE == Globals.CURSOR_MODES.DELETE:
		delete()

func delete():
	Signals.state_deleted.emit(id)
