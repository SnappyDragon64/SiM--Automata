extends PanelContainer

@onready var from_state_label
@onready var to_state_label

@onready var from_label = $hbox/from_container/from_label
@onready var to_label = $hbox/to_container/to_label

@onready var from_prefix = $hbox/from_container/from_prefix
@onready var to_prefix = $hbox/to_container/to_prefix

@onready var input = $hbox/transition_container/input

var is_from_start = false
var is_from_final = false

var is_to_start = false
var is_to_final = false

func _ready():
	Signals.update_transition_label.connect(_on_update_transition_label)
	Signals.state_label_deleted.connect(_on_state_label_deleted)
	update()

func init(from, to):
	from_state_label = EvaluationEngine.get_state_label_by_name(from)
	to_state_label = EvaluationEngine.get_state_label_by_name(to)

func update():
	update_label(from_prefix, from_label, is_from_start, is_from_final, from_state_label)
	update_label(to_prefix, to_label, is_to_start, is_to_final, to_state_label)

func update_label(prefix_label, label, is_start, is_final, label_node):
	var flag = true
	
	flag = flag && set_label_text_conditionally(prefix_label, '->*', is_start && is_final)
	flag = flag && set_label_text_conditionally(prefix_label, '->', is_start)
	flag = flag && set_label_text_conditionally(prefix_label, '*', is_final)
	
	if flag:
		prefix_label.set_text('')
	
	if is_instance_valid(label_node):
		label.set_text(str('S', label_node.node.id))

func set_label_text_conditionally(label, text, flag):
	if flag:
		label.set_text(text)
	
	return not flag

func get_input():
	return input.get_text()

func _on_delete_button_pressed():
	delete()

func _on_state_label_deleted():
	if not (is_instance_valid(from_state_label) and is_instance_valid(to_state_label)):
		delete()

func _on_update_transition_label():
	update()

func delete():
	Signals.delete_transition_label.emit(self)
