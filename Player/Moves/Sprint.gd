extends Move
class_name Sprint

const SPEED = 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func default_lifecycle(input : InputPackage):
	if not player.is_on_floor():
		return "midair"
	input.actions.sort_custom(moves_priority_sort)
	if input.actions[0] == "sprint":
		return "okay"
	return input.actions[0]


func update(input : InputPackage, delta : float):
	player.velocity = velocity_by_input(input, delta)
	player.look_at(player.global_position - player.velocity)
	player.move_and_slide()


func velocity_by_input(input : InputPackage, delta : float) -> Vector3:
	var new_velocity = player.velocity
	
	#var direction = Vector3(input.input_direction.x, 0, input.input_direction.y).normalized()
	var direction = (player.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	new_velocity.x = direction.x * SPEED
	new_velocity.z = direction.z * SPEED
	
	if not player.is_on_floor():
		new_velocity.y -= gravity * delta
	
	return new_velocity
