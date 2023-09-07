extends PanelContainer

@onready var from_node
@onready var to_node

@onready var from_label = $margin/hbox/from_label
@onready var to_label = $margin/hbox/to_label

func _ready():
	update()

func init(from, to):
	from_node = Globals.get_node_by_name(from)
	to_node = Globals.get_node_by_name(to)

func update():
	from_label.set_text(str('S', from_node.get_id(), ' →'))
	to_label.set_text(str(' S', to_node.get_id()))
