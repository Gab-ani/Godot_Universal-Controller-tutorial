extends Move


const TRANSITION_TIMING = 1.96

var hit_damage = 15

@onready var root_motion_track_number = animator.get_animation(animation).find_track("%GeneralSkeleton:Hips", Animation.TYPE_POSITION_3D)


func default_lifecycle(input : InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		return best_input_that_can_be_paid(input)
	return "okay"


func update(_input : InputPackage, delta : float):
	manage_weapon_attack()
	move_player(delta)


func move_player(delta : float):
	player.velocity = player.get_quaternion() * get_delta_position(delta) / delta
	if not player.is_on_floor():
		player.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
		has_forced_move = true
		forced_move = "midair"
	player.move_and_slide()


func get_delta_position(delta_time : float) -> Vector3:
	var animation_as_function = animator.get_animation("slash_3") as Animation
	var previous_pos = animation_as_function.position_track_interpolate(root_motion_track_number, get_progress() - delta_time)
	var current_pos = animation_as_function.position_track_interpolate(root_motion_track_number, get_progress())
	var delta_pos = current_pos - previous_pos
	delta_pos.y = 0
	return delta_pos


func manage_weapon_attack():
	if works_between(0.6816, 0.7765):
		player.model.active_weapon.is_attacking = true
	else:
		player.model.active_weapon.is_attacking = false


func form_hit_data(weapon : Weapon) -> HitData:
	var hit = HitData.new()
	hit.damage = hit_damage
	hit.hit_move_animation = animation
	hit.is_parryable = is_parryable()
	hit.weapon = player.model.active_weapon
	return hit


func on_exit_state():
	player.model.active_weapon.hitbox_ignore_list.clear()
	player.model.active_weapon.is_attacking = false
