extends Move

@export var SPEED = 5.0
@export var TURN_SPEED = 3.2
@export var VERTICAL_SPEED_ADDED : float = 2.5

const TRANSITION_TIMING = 0.4
const JUMP_TIMING = 0.0657

var jumped : bool = false


func default_lifecycle(_input : InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		jumped = false
		return "midair"
	else: 
		return "okay"


func update(_input : InputPackage, _delta ):
	process_jump()
	humanoid.move_and_slide()


func process_jump():
	if works_longer_than(JUMP_TIMING):
		if not jumped:
			humanoid.velocity = humanoid.basis.z * SPEED 
			humanoid.velocity.y += VERTICAL_SPEED_ADDED
			jumped = true


func on_enter_state():
	humanoid.velocity = humanoid.velocity.normalized() * SPEED 
