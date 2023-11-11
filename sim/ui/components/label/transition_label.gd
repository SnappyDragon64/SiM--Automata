extends PanelContainer

@onready var from_state_label
@onready var to_state_label

@onready var from_label = $hbox/from_container/from_label
@onready var to_label = $hbox/to_container/to_label

@onready var from_prefix = $hbox/from_container/from_prefix
@onready var to_prefix = $hbox/to_container/to_prefix

@onready var input = $hbox/transition_container/input

func _ready():
	Signals.update_transition_label.connect(_on_update_transition_label)
	Signals.delete_transition_label.connect(_on_delete_transition_label)
	Signals.animation_started.connect(_on_animation_started)
	Signals.animation_exited.connect(_on_animation_exited)
	update()

func init(from, to):
	from_state_label = EvaluationEngine.get_state_label_by_name(from)
	to_state_label = EvaluationEngine.get_state_label_by_name(to)

func update():
	update_label(from_prefix, from_label, from_state_label)
	update_label(to_prefix, to_label, to_state_label)

func update_label(prefix_label, label, label_node):
	var state_node = label_node.node
	
	var is_start = state_node.is_start
	var is_final = state_node.is_final
	var id = state_node.id
	
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

func _on_update_transition_label(state_name: String):
	if is_instance_valid(from_state_label) and is_instance_valid(to_state_label):
		if state_name == from_state_label.node_name or state_name == to_state_label.node_name:
			update()

func _on_delete_transition_label(state_name: String):
	if is_instance_valid(from_state_label) and is_instance_valid(to_state_label):
		if state_name == from_state_label.node_name or state_name == to_state_label.node_name:
			delete()

func delete():
	Signals.actually_delete_transition_label.emit(self)

func _on_animation_started():
	%input.set_editable(false)
	%input.set_selecting_enabled(false)
	%input.set_focus_mode(Control.FOCUS_NONE)
	%delete_button.set_disabled(true)

func _on_animation_exited():
	%input.set_editable(true)
	%input.set_selecting_enabled(true)
	%input.set_focus_mode(Control.FOCUS_CLICK)
	%delete_button.set_disabled(false)
