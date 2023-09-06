extends Node

# GUI
signal window_size_updated()
signal grid(flag)
signal dark_mode(flag)

# STATE
signal state_created(id)
signal state_deleted(id)
signal lock_dragging(flag)
signal lock_slots(flag)
