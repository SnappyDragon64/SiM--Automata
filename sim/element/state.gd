extends GraphNode

var id = 0
var is_start = false
var is_final = false

func _ready():
	Signals.state_created.emit(id, self)
	Signals.state_deleted.connect(_on_state_deleted)
	Signals.lock_dragging.connect(_lock_dragging)
	Signals.lock_slots.connect(_lock_slots)
	Signals.state_is_start_updated.connect(_on_state_is_start_updated)
	update()

func update():
	var text = str('S', id)
	var offset = 6 - len(text) * 1.5
	var v_offset = 24
	
	if is_start and is_final:
		text = str('->*', text)
		offset -= 20
	elif is_start:
		text = str('->', text)
		offset -= 13
	elif is_final:
		text = str('*', text)
		offset -= 7
	
	set_title(text)
	add_theme_constant_override('title_h_offset', offset)
	add_theme_constant_override('title_offset', v_offset)

func set_start(flag):
	is_start = flag
	Signals.state_is_start_updated.emit(id, flag)
	update()

func set_final(flag):
	is_final = flag
	Signals.state_is_final_updated.emit(id, flag)
	update()

func _on_state_deleted(deleted_id, _deleted_node):
	if deleted_id < id:
		id -= 1
		update()
	elif _deleted_node == self:
		queue_free()

func _lock_dragging(flag):
	set_draggable(not flag)

func _lock_slots(flag):
	set_slot_enabled_left(0, not flag)
	set_slot_enabled_right(0, not flag)

func _on_state_is_start_updated(state_id, flag):
	if state_id != id and flag:
		set_start(false)

func _on_node_selected():
	if Globals.CURSOR_MODE == Globals.CURSOR_MODES.DELETE:
		delete()

func delete():
	add_to_group('dead')
	Signals.state_deleted.emit(id, self)
	queue_free()

func _on_theme_changed():
	var col = get_theme_color('slot_color')
	set_slot_color_left(0, col)
	set_slot_color_right(0, col)
