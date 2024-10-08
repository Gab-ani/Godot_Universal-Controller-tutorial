extends Move


@export var SPEED = 3.0
@export var TURN_SPEED = 2
 

func default_lifecycle(input : InputPackage):
	if not humanoid.is_on_floor():
		return "midair" 
	
	return best_input_that_can_be_paid(input)


func update(_input : InputPackage, _delta : float):
	humanoid.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	var input_direction = (humanoid.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	var face_direction = humanoid.basis.z
	var angle = face_direction.signed_angle_to(input_direction, Vector3.UP)
	if abs(angle) >= tracking_angular_speed * delta:
		humanoid.velocity = face_direction.rotated(Vector3.UP, sign(angle) * tracking_angular_speed * delta) * TURN_SPEED
		humanoid.rotate_y(sign(angle) * tracking_angular_speed * delta)
	else:
		humanoid.velocity = face_direction.rotated(Vector3.UP, angle) * SPEED
		humanoid.rotate_y(angle)
	#animator.set_speed_scale(humanoid.velocity.length() / SPEED)

# TODO implement better speed/animation behaviour in locomotion states
#func on_exit_state():
	#animator.set_speed_scale(1)
