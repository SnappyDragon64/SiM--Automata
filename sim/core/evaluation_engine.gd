# Contains the code for major parts of the simulator
# Such as validation of state transition diagram,
# testing of inputs and generation of test strings

extends Node


# Validates the state transition diagram 
func is_valid():
	var state_labels = get_tree().get_nodes_in_group('state_label')
	var n = len(state_labels)
	
	# Checks if the state transition diagram is empty
	if n == 0:
		Signals.popup.emit('No states found.')
		return false
	
	var has_start = false
	var has_final = false
	var are_transitions_valid = true
	
	# Checks if the state transition diagram contains a start and a final state
	for state_label in state_labels:
		if state_label.node.is_start:
			has_start = true
		if state_label.node.is_final:
			has_final = true
		
		if has_start and has_final:
			break
	
	# Checks if each transition has a valid symbol associated with it
	var transition_labels = get_tree().get_nodes_in_group('transition_label')
	for transition_label in transition_labels:
		if transition_label.input.get_text().is_empty():
			are_transitions_valid = false
			break
	
	# Displays the appropriate popup according to the checks failed
	var text = ''
	if not has_start:
		text += 'No start state found.\n'
	
	if not has_final:
		text += 'No final state found.\n'
	
	if not are_transitions_valid:
		text += 'Empty transitions are not allowed.\n'
	
	if has_start and has_final and len(get_test_strings()) == 0:
		text += 'No path from start state to final state.'
	
	if text.is_empty():
		return true
	else:
		Signals.popup.emit(text)
		return false


# Gets state label by its name
func get_state_label_by_name(node_name):
	var state_labels = get_tree().get_nodes_in_group('state_label')
	return state_labels.filter(func(state_label): return state_label.node.get_name() == node_name)[0]


# Serializes the constructed state transition diagram to a dictionary
func serialize_fa():
	var fa = {}
	var start = 0
	
	# Process all states
	for state_label in get_tree().get_nodes_in_group('state_label'):
		var state_node = state_label.node
		
		# Check for the start state
		if state_node.is_start:
			start = state_node.id
		
		# Store state to dictionary
		fa[state_node.id] = {
			'is_final': state_node.is_final,
			'transitions': []
		}
	
	# Process all transitions
	for transition in get_tree().get_nodes_in_group('transition_label'):
		var from_id = transition.from_state_label.node.id
		var to_id = transition.to_state_label.node.id
		var input = transition.get_input()
		
		# Store transition to dictionary
		fa[from_id]['transitions'].append({
			'to': to_id,
			'input': input
		})
	
	return [start, fa]


# Generates test strings of max depth up to 2 times the number of states
func generate_test_strings(start, fa):
	var keys = len(fa.keys())
	var max_depth = keys * 2
	var strings = []
	
	_generate_test_strings(start, fa, 0, max_depth, '', strings)
	
	return strings


# Uses recursion to traverse the state transition diagram in all possible directions until max depth is hit
func _generate_test_strings(start, fa, depth, max_depth, current, strings):
	# Checks for max depth
	if depth < max_depth:
		depth += 1
		
		# Stores test string if the current state is a final state 
		if fa[start]['is_final']:
			strings.append(current)
		
		var transitions = fa[start]['transitions']
		
		# Explores all transitions
		for transition in transitions:
			var to = transition['to']
			var input = transition['input']
			var new_current = current + input
			
			# Uses recursion to build upon the current string
			_generate_test_strings(to, fa, depth, max_depth, new_current, strings)


# Evaluates an input against the state transition diagram
# Returns whether the input is accepted or rejected along with the path taken
# Also used for animation
func test(start, fa, input):
	var current_state = start
	var path = [start]

	# For each character in the input, checks if there exists a valid transition from the current state
	for c in input:
		var flag = false
		for transition in fa[current_state]['transitions']:
			if transition['input'] == c:
				current_state = transition['to']
				path.append(current_state)
				flag = true
				break  
		
		if not flag:
			return [false, path]
		
		if current_state not in fa:
			return [false, path]

	# If the state after all characters have been processed is a final state, the input is accepted
	if fa[current_state]['is_final']:
		return [true, path]
	else:
		return [false, path]


# Evaluates multiple inputs and returns the results
func evaluate(inputs):
	var serialized = serialize_fa()
	var start = serialized[0]
	var fa = serialized[1]
	var results = []
	
	for input in inputs:
		results.append(test(start, fa, input))
	
	return results


# Returns test strings for the current state transition diagram
func get_test_strings():
	# Serializes the state transition diagram to a dictionary
	var serialized = serialize_fa()
	var start = serialized[0]
	var fa = serialized[1]
	
	# Generates test strings
	var strings = generate_test_strings(start, fa)
	var unique_strings = []
	
	# Filters out duplicate test strings
	for string in strings:
		if not unique_strings.has(string):
			unique_strings.append(string)
	
	# Sorts strings by length in alphabetical order
	unique_strings.sort_custom(sort_strings)
	
	# Replaces the empty test string, if it exists, with epsilon
	if len(unique_strings) > 0:
		if len(unique_strings[0]) == 0:
			unique_strings[0] = 'ε'
	
	return unique_strings


# Sorts string by length in alphabetical order
func sort_strings(a, b):
	if len(a) == len(b):
		return a.naturalnocasecmp_to(b) < 0
	else:
		return len(a) < len(b)
