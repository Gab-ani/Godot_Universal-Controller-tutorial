extends TorsoPartialMove

@export var block_coefficient : float = 0.5
@export var block_sector : float = 3.14


func default_lifecycle(input : InputPackage):
	if not player.is_on_floor():
		return "midair"
	return best_input_that_can_be_paid(input)


func react_on_hit(hit : HitData):
	var weapon_position : Vector3 = hit.weapon.global_position
	var our_position = player.global_position
	our_position.y = weapon_position.y
	var hit_direction : Vector3 = our_position.direction_to(weapon_position)
	var face_direction = player.basis.z
	if face_direction.angle_to(hit_direction) < block_sector / 2:
		print("blocked a hit")
		resources.pay_block_cost(hit.damage, block_coefficient)
		try_force_move("block_reaction")
	else:
		super.react_on_hit(hit)


func update_resources(_delta : float):
	pass # normally would be some routine, but we only regenerate stamina now, so empty method

# Don't forget you can even override the class getters!)
# For example, we can override backend animation getter to consider blocking sector also.
#func is_grabbable():
	# if grabbed from blocking sector - nope, if from the back - yup
