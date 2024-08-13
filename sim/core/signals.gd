extends Node


# Signals function like events and can be used for loose coupling of nodes
# When a signal is emitted, all connected nodes receive the signal and execute some code

# GUI-related signals
signal grid(flag) # Tpggles grid
signal dark_mode(flag) # Toggles dark mode
signal redraw_transitions() # Redraws transitions on the screen
signal add_input() # Adds new input label
signal run() # Used for input evaluation or test string generation depending on the selected tab
signal popup(text) # Displays a text popup
signal clear() # Clears the work area
signal update_simulator_status(status, data) # Updates the status of the simulator

# State-related signals (for updating state nodes)
signal state_created(node) # Emitted on state creation
signal update_state_label(state_name) # Dtate label update
signal delete_state_label(state_name) # Initiates process for state label deletion
signal actually_delete_state_label(state_label) # Finally deletes the state label after all prerequisites have been cleared
signal state_label_deleted() # Emitted after state label deletion
signal update_transition_label(state_name) # Yransition label update
signal delete_transition_label(state_name) # Initiates process for transition label deletion
signal actually_delete_transition_label(transition_label) # Finally deletes the transition label after all prerequisites have been cleared
signal start_updated(state_name) # Emitted when the start state changes
signal lock_dragging(flag) # Toggles dragging for all state nodes
signal update_state_ids() # Updates all state ids

# Transition-related signals (for updating state transitions)
signal transition_created(from_node_label, to_node_label) # Adds a transition from the from_node to the to_node

# Animation-related signals (for handling animations)
signal animation_started() # Animation mode started
signal animation_exited() # Animation mode exited
signal set_state_status(state_id, status_id) # Updates the state's status during an ongoing animation
