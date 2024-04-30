extends Move


const PARRY_WINDOW_START : float = 0.2
const PARRY_WINDOW_END : float = 1

const ANIMATION_END : float = 1.3667

func default_lifecycle(input : InputPackage):
	if works_longer_than(ANIMATION_END):
		if has_queued_move and resources.can_be_paid(player.model.moves[queued_move]):
			has_queued_move = false
			return queued_move
		return best_input_that_can_be_paid(input)
	return "okay"


func react_on_hit(hit : HitData):
	if works_between(PARRY_WINDOW_START, PARRY_WINDOW_END) and hit.is_parryable:
		hit.weapon.holder.current_move.react_on_parry(hit)
		print("parry kong")
	else:
		try_force_move("staggered")
	hit.queue_free()
