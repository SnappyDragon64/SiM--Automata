extends GraphNode

var id = 0
var is_start = false
var is_final = false

func _ready():
	Signals.state_created.emit( self)
	Signals.lock_dragging.connect(_lock_dragging)
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
	Signals.update_state_label.emit(name)

func set_start(flag):
	is_start = flag
	update()

func set_final(flag):
	is_final = flag
	update()

func set_id(new_id):
	id = new_id
	update()

func _lock_dragging(flag):
	set_draggable(not flag)

func _on_state_is_start_updated(state_id, flag):
	if state_id != id and flag:
		set_start(false)

func _on_node_selected():
	if Globals.CURSOR_MODE == Globals.CURSOR_MODES.DELETE:
		Signals.delete_state_label.emit(name)

func _on_theme_changed():
	var col = get_theme_color('slot_color')
	set_slot_color_left(0, col)
	set_slot_color_right(0, col)
