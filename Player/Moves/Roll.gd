extends Move

# the point where we predict the roll will end
# (no physics simulations currently, just a vector add up)
# used to communicate with enemies
var endpoint : Vector3

func update(_input : InputPackage, delta):
	move_player(delta)


func move_player(delta : float):
	var delta_pos = get_root_position_delta(delta)
	delta_pos.y = 0
	var rotated_delta = player.get_quaternion() * delta_pos / delta
	player.velocity.x = rotated_delta.x
	player.velocity.z = rotated_delta.z
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	player.move_and_slide()

# I'm currently debating myself about adding this resetting into base Move.
# This is a lil crotch for "one shot" animations that can be chained,
# for example roll->roll- etc. Thanks to our animations being
# decoupled from our timings, sometimes we are "one frame short" on playing.
# Without this crotch when we roll->roll, we play a static final pose of the first roll during second one(
# At least one Move currently uses this duplicated call - Parry one, because we can spam parries.
# so maybe consuming them into base makes sense, but I really don't want another bool export field.
# TODO revisit&rethink, tech debt certainly
func on_enter_state():
	animator.reset_torso_animation()
	animator.reset_legs_animation()
	
	var input = area_awareness.last_input_package
	var input_direction = (player.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	if input_direction:
		player.look_at(player.global_position + input_direction, Vector3.UP, true)


func best_input_that_can_be_paid(input : InputPackage) -> String:
	input.actions.sort_custom(container.moves_priority_sort)
	for action in input.actions:
		if resources.can_be_paid(container.moves[action]):
			return action
			#if container.moves[action] == self:
				#return "okay"
			#else:
				#return action
	return "throwing because for some reason input.actions doesn't contain even idle"  
