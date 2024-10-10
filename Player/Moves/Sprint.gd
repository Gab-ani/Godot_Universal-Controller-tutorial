extends Move


@export var SPEED = 5.0
@export var TURN_SPEED = 3.2

@export var sprint_stamina_cost = 20 # per sec so multiply by delta

func default_lifecycle(input : InputPackage):
	if not player.is_on_floor():
		return "midair"
	
	return best_input_that_can_be_paid(input)


func update(_input : InputPackage, delta : float):
	player.move_and_slide()
	resources.lose_stamina(sprint_stamina_cost * delta)


func process_input_vector(input : InputPackage, delta : float):
	var input_direction = (player.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	var face_direction = player.basis.z
	var angle = face_direction.signed_angle_to(input_direction, Vector3.UP)
	if abs(angle) >= tracking_angular_speed * delta:
		player.velocity = face_direction.rotated(Vector3.UP, sign(angle) * tracking_angular_speed * delta) * TURN_SPEED
		player.rotate_y(sign(angle) * tracking_angular_speed * delta)
	else:
		player.velocity = face_direction.rotated(Vector3.UP, angle) * SPEED
		player.rotate_y(angle)
	animator.set_speed_scale(player.velocity.length() / SPEED)


func on_exit_state():
	animator.set_speed_scale(1)
