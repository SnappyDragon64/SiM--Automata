extends Node

# GUI
signal window_size_updated()
signal grid(flag)
signal dark_mode(flag)

# STATE
signal state_created(id, node)
signal state_deleted(id)
signal state_is_start_updated(id, flag)
signal state_is_final_updated(id, flag)
signal lock_dragging(flag)
signal lock_slots(flag)

#TRANSITION
signal transition_created(from_node, to_node)
