extends Move


const ANIMATION_END : float = 1.7833

func check_relevance(input : InputPackage):
	if works_longer_than(ANIMATION_END):
		input.actions.sort_custom(moves_priority_sort)
		return input.actions[0]
	else:
		return "okay"

