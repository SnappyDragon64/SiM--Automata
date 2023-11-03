extends Node

# GUI
signal grid(flag)
signal dark_mode(flag)
signal redraw_transitions()
signal add_input()
signal run()
signal popup(flags)

# STATE
signal state_created(node)
signal update_state_label(state_name)
signal delete_state_label(state_name)
signal actually_delete_state_label(state_label)
signal state_label_deleted()
signal update_transition_label()
signal delete_transition_label(transition_label)
signal lock_dragging(flag)
signal update_state_ids()

# TRANSITION
signal transition_created(from_node_label, to_node_label)
