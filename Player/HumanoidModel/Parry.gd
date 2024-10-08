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


func best_input_that_can_be_paid(input : InputPackage) -> String:
	input.actions.sort_custom(container.moves_priority_sort)
	for action in input.actions:
		if resources.can_be_paid(container.moves[action]):
			return action
			#if container.moves[action] == self:
				#return "okay"
			#else:
				#return action
	return "throwing because for some reason input.actions doesn't contain even idle"  

# TODO revisit&rethink, tech debt certainly / see Roll Move
func on_exit_state():
	animator.reset_torso_animation()
	animator.reset_legs_animation()
