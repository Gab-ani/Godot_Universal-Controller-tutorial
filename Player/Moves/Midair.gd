extends Move

@export var DELTA_VECTOR_LENGTH = 6
var jump_direction : Vector3

var landing_height : float = 1.163


func default_lifecycle(_input : InputPackage):
	var floor_distance = area_awareness.get_floor_distance()
	if floor_distance < landing_height:
		var xz_velocity = player.velocity
		xz_velocity.y = 0
		if xz_velocity.length_squared() >= 10:
			return "landing_sprint"
		return "landing_run"
	else:
		return "okay"


func update(_input : InputPackage, delta ):
	player.velocity.y -= gravity * delta
	player.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	var input_direction = (player.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	var input_delta_vector = input_direction * DELTA_VECTOR_LENGTH
	
	jump_direction = (jump_direction + input_delta_vector * delta).limit_length(clamp(player.velocity.length(), 1, 999999))
	player.look_at(player.global_position - jump_direction)
	
	var new_velocity = (player.velocity + input_delta_vector * delta).limit_length(player.velocity.length())
	player.velocity = new_velocity


func on_enter_state():
	# the clamp construction is here to 
	# 1) prevent look_at annoying errors when our velocity is zero and it can't look_at properly
	# 3) have a way to scale from velocity. The longer the vector is, the harder it is to modify it by adding a delta.
	#    Scaling jump_direction with velocity is giving us that natural behaviour of faster jumps (sprints)
	#    being less controllable, and jumps from standing position being more volatile.
	#    The dependance on velocity paramter is not critical, delete this if you don't like the approach.
	jump_direction = Vector3(player.basis.z) * clamp(player.velocity.length(), 1, 999999)
	jump_direction.y = 0
