extends Move


const ANIMATION_END = 0.9833


func default_lifecycle(input : InputPackage):
	if works_longer_than(ANIMATION_END):
		input.actions.sort_custom(moves_priority_sort)
		return input.actions[0]
	else:
		return "okay"
