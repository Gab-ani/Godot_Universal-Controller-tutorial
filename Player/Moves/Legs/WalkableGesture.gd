extends LegsBehaviour


func transition_legs_state(input, _delta):
	var target_move : String

	if input.input_direction:
		target_move =  "walk"
	else:
		target_move = "idle"
	
	if target_move != current_legs_move.move_name:
		change_state(target_move)
