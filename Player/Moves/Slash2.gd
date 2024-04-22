extends Move
class_name Slash2


const TRANSITION_TIMING = 0.65
const COMBO_TIMING = 0.6


func _ready():
	animation = "slash_2"
	move_name = "slash_2"


func check_relevance(input : InputPackage):
	check_combos(input)
	if works_longer_than(COMBO_TIMING) and has_queued_move:
		has_queued_move = false
		return queued_move
	elif works_longer_than(TRANSITION_TIMING):
		input.actions.sort_custom(moves_priority_sort)
		return input.actions[0]
	else:
		return "okay"
