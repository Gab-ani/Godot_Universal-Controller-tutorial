extends Move


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const TRANSITION_TIMING = 0.2

# landings aren't default-defaults, this TRANSITION_TIMING != DURATION
# DURATION is much longer, but we are releasing the priorit early
# and the rest of the animation is just for smoother blending
func default_lifecycle(input : InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		return best_input_that_can_be_paid(input)
	return "okay"


func update(_input : InputPackage, delta ):
	humanoid.velocity.y -= gravity * delta
	humanoid.move_and_slide()
