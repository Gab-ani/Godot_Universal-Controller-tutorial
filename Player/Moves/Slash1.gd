extends Move

#
#const COMBO_TIMING = 0.9
const TRANSITION_TIMING = 0.9
const ANIMATION_END = 1.8

var hit_damage = 10 # will be a function of player stats in the future

@onready var root_motion_track_number = animator.get_animation(animation).find_track("%GeneralSkeleton:Hips", Animation.TYPE_POSITION_3D)


func default_lifecycle(input : InputPackage) -> String:
	var best_input = best_input_that_can_be_paid(input)
	
	if works_longer_than(TRANSITION_TIMING):
		if has_queued_move and resources.can_be_paid(player.model.moves[queued_move]):
			has_queued_move = false
			return queued_move
		# we are cutting this automatic idle transition, because the whole animation end 
		# is a custom idle transition already done by an animator during asset creation
		elif best_input != "idle":
			return best_input
	elif works_longer_than(ANIMATION_END):
		return best_input
	return "okay"
	
	
	#if works_longer_than(COMBO_TIMING) and has_queued_move and resources.can_be_paid(player.model.moves[queued_move]):
		#has_queued_move = false
		#return queued_move
	#elif works_longer_than(TRANSITION_TIMING) and best_input != "idle" or works_longer_than(ANIMATION_END):
		#return best_input
	#return "okay"


func update(_input : InputPackage, delta):
	move_player(delta)
	if works_between(0.5419, 0.7943): # later will be turned into a backend animation parameter
		player.model.active_weapon.is_attacking = true
	else:
		player.model.active_weapon.is_attacking = false


func move_player(delta : float):
	player.velocity = player.get_quaternion() * get_delta_position(delta) / delta
	if not player.is_on_floor():
		player.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
		has_forced_move = true
		forced_move = "midair"
	player.move_and_slide()


func get_delta_position(delta_time : float) -> Vector3:
	var animation_as_function = animator.get_animation("longsword_1") as Animation
	var previous_pos = animation_as_function.position_track_interpolate(root_motion_track_number, get_progress() - delta_time)
	var current_pos = animation_as_function.position_track_interpolate(root_motion_track_number, get_progress())
	var delta_pos = current_pos - previous_pos
	delta_pos.y = 0
	return delta_pos


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
