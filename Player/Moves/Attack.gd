extends Move


@export var RELEASES_PRIORITY : float

var hit_damage = 10 # will be a function of player stats in the future

# this strange construction is here because our animation asset has a long tail transitioning to idle,
# think of it as of "custom perfect blending" to idle
# so after a certain point we want to release priority, but to anything except idle
func default_lifecycle(input : InputPackage) -> String:
	var best_input = best_input_that_can_be_paid(input)
	if works_longer_than(RELEASES_PRIORITY):
		if works_longer_than(DURATION) or best_input != "idle":
			return best_input
	return "okay"


func update(_input : InputPackage, delta):
	move_player(delta)
	
	humanoid.model.active_weapon.is_attacking = right_weapon_hurts()


func move_player(delta : float):
	var delta_pos = get_root_position_delta(delta)
	delta_pos.y = 0
	humanoid.velocity = humanoid.get_quaternion() * delta_pos / delta
	if not humanoid.is_on_floor():
		humanoid.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
		has_forced_move = true
		forced_move = "midair"
	humanoid.move_and_slide()


func form_hit_data(weapon : Weapon) -> HitData:
	var hit = HitData.new()
	hit.damage = hit_damage
	hit.hit_move_animation = animation
	hit.is_parryable = is_parryable()
	hit.weapon = humanoid.model.active_weapon
	return hit


func on_exit_state():
	humanoid.model.active_weapon.hitbox_ignore_list.clear()
	humanoid.model.active_weapon.is_attacking = false
