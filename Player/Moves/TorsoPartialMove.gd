extends Move
class_name TorsoPartialMove


@export var legs_behaviour : LegsBehaviour

func process_input_vector(input, delta):
	legs_behaviour.current_legs_move.process_input_vector(input, delta)

# Dangerous stuff, but we are overriding an internal method of base Move class.
# Unthoughtful changes can ruin base Move processing around this class.
# Here I only add new lines and I call the base implementation onwards
func _update(input : InputPackage, delta : float):
	#skeleton.add_torso_correction(x_adjustment, y_adjustment, z_adjustment)
	legs_behaviour.update(input, delta)
	update(input, delta)


func _on_enter_state():
	#skeleton.add_torso_correction(x_adjustment, y_adjustment, z_adjustment)
	super._on_enter_state()


func _on_exit_state():
	#skeleton.remove_torso_correction()
	
	super._on_exit_state()
