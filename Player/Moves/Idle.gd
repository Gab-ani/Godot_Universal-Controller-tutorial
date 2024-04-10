extends Move
class_name Idle


func check_relevance(input) -> String:
	input.actions.sort_custom(moves_priority_sort)
	return input.actions[0]
	
	
	#if input.actions.has("jump"):
		#return "jump"
	#if input.input_direction != Vector2.ZERO:
		#return "run"
	#return "okay"
