extends Move


const COMBO_TIMING = 0.97
const TRANSITION_TIMING = 1.1333

const animation_length : float = 3

var hit_damage = 10 # will be a function of player stats in the future


func default_lifecycle(input : InputPackage) -> String:
	if works_longer_than(COMBO_TIMING) and has_queued_move and resources.can_be_paid(player.model.moves[queued_move]):
		has_queued_move = false
		return queued_move
	elif works_longer_than(TRANSITION_TIMING):
		return best_input_that_can_be_paid(input)
	return "okay"


func update(_input : InputPackage, _delta):
	if works_between(0.5419, 0.7943): # later will be turned into a backend animation parameter
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


func on_enter_state():
	player.velocity = Vector3.ZERO

func on_exit_state():
	player.model.active_weapon.hitbox_ignore_list.clear()
	player.model.active_weapon.is_attacking = false
