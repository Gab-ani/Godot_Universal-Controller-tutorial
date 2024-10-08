extends Node
class_name Legs


# The more suited approach will be inherit Move once more to define LegsMove 
# then those heirs will register themselves here on_enter state.
# This way we could escape the need to manually call update() here.
# But I wanted a fast makeshift patch to work
@export var model : PlayerModel
#@export var legs_states : Array[Move]
var current_legs_move : Move


func accept_behaviours():
	for child in get_children():
		if child is LegsBehaviour:
			child.model = model
			child.moves_container = model.moves_container
			child.legs_manager = self
			child.current_legs_move = current_legs_move
