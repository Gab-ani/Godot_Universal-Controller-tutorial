extends Move


func default_lifecycle(input) -> String:
	if not humanoid.is_on_floor():
		return "midair"
	
	return best_input_that_can_be_paid(input)


func on_enter_state():
	humanoid.velocity = Vector3.ZERO
