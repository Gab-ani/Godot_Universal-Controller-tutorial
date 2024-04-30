extends Move


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const TRANSITION_TIMING = 0.2

 
func default_lifecycle(input : InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		return best_input_that_can_be_paid(input)
	return "okay"

func update(_input : InputPackage, delta ):
	player.velocity.y -= gravity * delta
	player.move_and_slide()

