extends Node

enum CURSOR_MODES {
	SELECT,
	CREATE,
	LINK,
	DELETE,
	MOVE,
	PAN
}

var CURSOR_MODE : CURSOR_MODES = CURSOR_MODES.SELECT

var STATE_NODE_MAP = []
var TRANSITIONS = []
var START_STATE = null
var FINAL_STATES = []

func get_node_by_name(node_name):
	return STATE_NODE_MAP.filter(func(node): return node.get_name() == node_name)[0]
