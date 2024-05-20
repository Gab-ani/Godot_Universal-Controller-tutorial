extends Move


const PARRY_WINDOW_START : float = 0.2
const PARRY_WINDOW_END : float = 1


func react_on_hit(hit : HitData):
	if works_between(PARRY_WINDOW_START, PARRY_WINDOW_END) and hit.is_parryable:
		hit.weapon.holder.current_move.react_on_parry(hit)
		print("parry kong")
	else:
		super.react_on_hit(hit)
	hit.queue_free()
