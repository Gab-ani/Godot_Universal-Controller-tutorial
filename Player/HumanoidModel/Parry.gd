extends Move


const PARRY_WINDOW_START : float = 0.2
const PARRY_WINDOW_END : float = 1

const ANIMATION_END : float = 1.3667

func default_lifecycle(input : InputPackage):
	if works_longer_than(ANIMATION_END):
		input.actions.sort_custom(moves_priority_sort)
		return input.actions[0]
	else:
		return "okay"


func react_on_hit(hit : HitData):
	if works_between(PARRY_WINDOW_START, PARRY_WINDOW_END) and hit.is_parryable:
		hit.weapon.holder.current_move.react_on_parry(hit)
		print("parry kong")
	else:
		has_forced_move = true
		forced_move = "staggered"
