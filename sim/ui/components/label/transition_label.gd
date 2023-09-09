extends PanelContainer

@onready var from_node
@onready var to_node

@onready var from_label = $hbox/from_container/from_label
@onready var to_label = $hbox/to_container/to_label

@onready var from_prefix = $hbox/from_container/from_prefix
@onready var to_prefix = $hbox/to_container/to_prefix

var is_from_start = false
var is_from_final = false

var is_to_start = false
var is_to_final = false

func _ready():
	Signals.state_is_start_updated.connect(_on_state_is_start_updated)
	Signals.state_is_final_updated.connect(_on_state_is_final_updated)
	update()

func init(from, to):
	from_node = Globals.get_node_by_name(from)
	to_node = Globals.get_node_by_name(to)

func _on_state_is_start_updated(state_id, flag):
	if state_id == from_node.get_id():
		is_from_start = flag
	elif state_id == to_node.get_id():
		is_to_start = flag
	
	update()

func _on_state_is_final_updated(state_id, flag):
	if state_id == from_node.get_id():
		is_from_final = flag
	elif state_id == to_node.get_id():
		is_to_final = flag
	
	update()

func update():
	var flag = true
	
	flag = flag && set_label_text_conditionally(from_prefix, '→*', is_from_start && is_from_final)
	flag = flag && set_label_text_conditionally(from_prefix, '→', is_from_start)
	flag = flag && set_label_text_conditionally(from_prefix, '*', is_from_final)
	
	if flag:
		from_prefix.set_text('')
	flag = true
	
	flag = flag && set_label_text_conditionally(to_prefix, '→*', is_to_start && is_to_final)
	flag = flag && set_label_text_conditionally(to_prefix, '→', is_to_start)
	flag = flag && set_label_text_conditionally(to_prefix, '*', is_to_final)
	
	if flag:
		to_prefix.set_text('')
	
	from_label.set_text(str('S', from_node.get_id()))
	to_label.set_text(str('S', to_node.get_id()))

func set_label_text_conditionally(label, text, flag):
	if flag:
		label.set_text(text)
	
	return not flag
