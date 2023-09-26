extends PanelContainer

@onready var from_node
@onready var to_node

@onready var from_label = $hbox/from_container/from_label
@onready var to_label = $hbox/to_container/to_label

@onready var from_prefix = $hbox/from_container/from_prefix
@onready var to_prefix = $hbox/to_container/to_prefix

@onready var input = $hbox/transition_container/input

var is_from_start = false
var is_from_final = false

var is_to_start = false
var is_to_final = false

var marked_for_deletion = false

func _ready():
	Signals.state_is_start_updated.connect(_on_state_is_start_updated)
	Signals.state_is_final_updated.connect(_on_state_is_final_updated)
	Signals.state_deleted.connect(_on_state_deleted)
	update()

func init(from, to):
	from_node = EvaluationEngine.get_node_by_name(from)
	to_node = EvaluationEngine.get_node_by_name(to)
	
	is_from_start = from_node.is_start
	is_from_final = from_node.is_final
	
	is_to_start = to_node.is_start
	is_to_final = to_node.is_final

func _on_state_is_start_updated(state_id, flag):
	if state_id == from_node.id:
		is_from_start = flag
	
	if state_id == to_node.id:
		is_to_start = flag
	
	update()

func _on_state_is_final_updated(state_id, flag):
	if state_id == from_node.id:
		is_from_final = flag
	
	if state_id == to_node.id:
		is_to_final = flag
	
	update()

func _on_state_deleted(_deleted_id, _deleted_node):
	if not (is_instance_valid(from_node) and is_instance_valid(from_node)):
		delete()
	else:
		update()

func update():
	var flag = true
	
	flag = flag && set_label_text_conditionally(from_prefix, '->*', is_from_start && is_from_final)
	flag = flag && set_label_text_conditionally(from_prefix, '->', is_from_start)
	flag = flag && set_label_text_conditionally(from_prefix, '*', is_from_final)
	
	if flag:
		from_prefix.set_text('')
	flag = true
	
	flag = flag && set_label_text_conditionally(to_prefix, '->*', is_to_start && is_to_final)
	flag = flag && set_label_text_conditionally(to_prefix, '->', is_to_start)
	flag = flag && set_label_text_conditionally(to_prefix, '*', is_to_final)
	
	if flag:
		to_prefix.set_text('')
	
	from_label.set_text(str('S', from_node.id))
	to_label.set_text(str('S', to_node.id))

func set_label_text_conditionally(label, text, flag):
	if flag:
		label.set_text(text)
	
	return not flag

func get_input():
	return input.get_text()

func _on_delete_button_pressed():
	delete()

func delete():
	marked_for_deletion = true
	Signals.redraw_transitions.emit()
	queue_free()
