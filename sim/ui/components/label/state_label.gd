extends PanelContainer

@onready var pre_label = $hbox/label_hbox/pre_label
@onready var label = $hbox/label_hbox/label
@onready var make_start_button = $hbox/button_hbox/make_start_button
var node = null
var node_name

func _ready():
	Signals.update_state_label.connect(_on_update_state_label)
	Signals.delete_state_label.connect(_on_delete_state_label)
	Signals.start_updated.connect(_on_start_updated)
	update()

func init(state_node):
	node = state_node
	node_name = state_node.name

func update():
	label.set_text(str('S', node.id))
	
	var prefix = ''
	if node.is_start and node.is_final:
		prefix = '->*'
	elif node.is_start:
		prefix = '->'
	elif node.is_final:
		prefix = '*'
	
	pre_label.set_text(prefix)
	Signals.update_transition_label.emit(node_name)

func _on_update_state_label(state_name):
	if state_name == node_name:
		update()

func _on_delete_state_label(state_name):
	if state_name == node_name:
		delete()

func _on_delete_button_pressed():
	delete()

func delete():
	node.queue_free()
	await node.tree_exited
	Signals.actually_delete_state_label.emit(self)

func _on_make_start_button_toggled(button_pressed):
	node.set_start(button_pressed)
	
	if button_pressed:
		Signals.start_updated.emit(node_name)

func _on_make_final_button_toggled(button_pressed):
	node.set_final(button_pressed)

func _on_start_updated(state_name):
	if not state_name == node_name:
		make_start_button.button_pressed = false
		node.set_start(false)
