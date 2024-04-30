extends Move
class_name Idle


func default_lifecycle(input) -> String:
	if not player.is_on_floor():
		return "midair"
	
	if has_queued_move and resources.can_be_paid(player.model.moves[queued_move]):
		has_queued_move = false
		return queued_move
	
	return best_input_that_can_be_paid(input)


func on_enter_state():
	player.velocity = Vector3.ZERO
