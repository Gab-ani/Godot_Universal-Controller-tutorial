extends Move
class_name Slash3


const TRANSITION_TIMING = 1.96


func _ready():
	animation = "slash_3"
	move_name = "slash_3"


func check_relevance(input : InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		input.actions.sort_custom(moves_priority_sort)
		return input.actions[0]
	else:
		return "okay"

