extends Node
class_name InputGatherer

func gather_input() -> InputPackage:
	var new_input = InputPackage.new()
	
	if Input.is_action_just_pressed("ui_accept"):
		new_input.actions.append("jump")
	
	if Input.is_action_just_pressed("hit"):
		new_input.actions.append("hit")
	
	if Input.is_action_just_pressed("roll"):
		new_input.actions.append("roll")
		
	if Input.is_action_just_pressed("dash"):
		new_input.actions.append("dash")
	
	new_input.input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if new_input.input_direction != Vector2.ZERO:
		new_input.actions.append("run")
	
	if new_input.actions.is_empty():
		new_input.actions.append("idle")
	
	return new_input
