extends Move

const TRANSITION_TIMING = 0.2

# landings aren't default-defaults, this TRANSITION_TIMING != DURATION
# DURATION is much longer, but we are releasing the priority early
# and the rest of the animation is just for smoother blending
func default_lifecycle(input : InputPackage):
	if not humanoid.is_on_floor():
		return "midair"
	if works_longer_than(TRANSITION_TIMING):
		return best_input_that_can_be_paid(input)
	return "okay"


func update(_input : InputPackage, delta ):
	humanoid.velocity.y -= gravity * delta
	humanoid.move_and_slide()
