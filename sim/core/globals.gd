extends Node


# Global values

# All cursor modes
enum CURSOR_MODES {
	SELECT, # Default, allows selection of states
	CREATE, # Allows creation of states
	LINK, # Allows creation of state transitions
	DELETE, # Allows state deletion
	MOVE, # Allows movement of states
	PAN, # Allows panning of the visible area
}

# Global cursor mode variable, default set to SELECT
var CURSOR_MODE : CURSOR_MODES = CURSOR_MODES.SELECT

# State status enum, used for animation
enum STATE_STATUS {
	DEFAULT, # Default value
	VISITED, # State node has been visited at least once
	CURRENT, # Animation is currently on this state node
}

# Simulator status enum
enum SIM_STATUS {
	RUN, # Runs inputs on the constructed DFA
	TEST, # Test string generation
	ANIM_START, # Animation started
	ANIM_END, # Animation ended
}
