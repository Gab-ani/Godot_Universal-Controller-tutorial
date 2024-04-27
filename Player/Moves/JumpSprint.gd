extends Move

const VERTICAL_SPEED_ADDED : float = 2.5

const TRANSITION_TIMING = 0.4
const JUMP_TIMING = 0.0657

var jumped : bool = false


func default_lifecycle(input : InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		jumped = false
		return "midair"
	else: 
		return "okay"


func update(input : InputPackage, delta ):
	if works_longer_than(JUMP_TIMING):
		if not jumped:
			player.velocity.y += VERTICAL_SPEED_ADDED
			jumped = true
	player.move_and_slide()

