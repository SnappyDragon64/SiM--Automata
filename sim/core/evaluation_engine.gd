extends Node

var STATES = []
var TRANSITIONS = []

func get_node_by_name(node_name):
	Signals.retrieve_states.emit()
	return STATES.filter(func(state_label): return state_label.node.get_name() == node_name)[0]

func serialize_fa():
	Signals.retrieve_states.emit()
	Signals.retrieve_transitions.emit()

	var fa = {}
	var start = 0
	
	for state in STATES:
		var node = state.node
		
		if node.is_start:
			start = node.id
		
		fa[node.id] = {
			'is_final': node.is_final,
			'transitions': []
		}
	
	for transition in TRANSITIONS:
		var from_id = transition.from_node.id
		var to_id = transition.to_node.id
		var input = transition.get_input()
		fa[from_id]['transitions'].append({
			'to': to_id,
			'input': input
		})
	
	return [start, fa]

func test(start, fa, input):
	var current_state = start

	for c in input:
		var flag = false
		for transition in fa[current_state]['transitions']:
			if transition['input'] == c:
				current_state = transition['to'] 
				flag = true
				break  
		
		if not flag:
			return false  
		
		if current_state not in fa:
			return false

	if fa[current_state]['is_final']:
		return true
	else:
		return false

func evaluate(inputs):
	var serialized = serialize_fa()
	var start = serialized[0]
	var fa = serialized[1]
	var results = []
	
	for input in inputs:
		results.append(test(start, fa, input))
	
	return results
