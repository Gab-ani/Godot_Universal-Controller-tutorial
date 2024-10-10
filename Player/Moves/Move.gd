extends Node
class_name Move

var player : CharacterBody3D
#var base_animator : AnimationPlayer
var animator : SplitBodyAnimator # or BodyPartsBlender
var skeleton : Skeleton3D
var resources : HumanoidResources
var combat : HumanoidCombat
var moves_data_repo : MovesDataRepository
var container : HumanoidStates
var area_awareness : AreaAwareness
var legs : Legs
#var left_wrist : BoneAttachment3D

@export var animation : String
@export var move_name : String
@export var priority : int
@export var backend_animation : String
@export var tracking_angular_speed : float = 10
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# I can tolerate up to two _costs, 
# the moment I need a third one, I'll create a small ResourceCost class to pay them.
@export var stamina_cost : float = 0

@onready var combos : Array[Combo] 

var enter_state_time : float
var initial_position : Vector3
var frame_length = 0.016

var has_queued_move : bool = false
var queued_move : String = "nonexistent queued move, drop error please"

var has_forced_move : bool = false
var forced_move : String = "nonexistent forced move, drop error please"

var DURATION : float

func check_relevance(input : InputPackage) -> String:
	if accepts_queueing():
		check_combos(input)
	
	if has_queued_move and transitions_to_queued():
		try_force_move(queued_move)
		has_queued_move = false
	
	if has_forced_move:
		has_forced_move = false
		return forced_move
	
	return default_lifecycle(input)


func check_combos(input : InputPackage):
	for combo : Combo in combos:
		if combo.is_triggered(input) and resources.can_be_paid(container.moves[combo.triggered_move]):
			has_queued_move = true
			queued_move = combo.triggered_move


func best_input_that_can_be_paid(input : InputPackage) -> String:
	input.actions.sort_custom(container.moves_priority_sort)
	for action in input.actions:
		if resources.can_be_paid(container.moves[action]):
			if container.moves[action] == self:
				return "okay"
			else:
				return action
	return "throwing because for some reason input.actions doesn't contain even idle"  


func _update(input : InputPackage, delta : float):
	if tracks_input_vector():
		process_input_vector(input, delta)
	update(input, delta)


func update(_input : InputPackage, _delta : float):
	pass

func process_input_vector(input : InputPackage, delta : float):
	var input_direction = (player.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	var face_direction = player.basis.z
	var angle = face_direction.signed_angle_to(input_direction, Vector3.UP)
	player.rotate_y(clamp(angle, -tracking_angular_speed * delta, tracking_angular_speed * delta))

func update_resources(delta : float):
	resources.update(delta)


func mark_enter_state():
	enter_state_time = Time.get_unix_time_from_system()

func get_progress() -> float:
	var now = Time.get_unix_time_from_system()
	return now - enter_state_time

func works_longer_than(time : float) -> bool:
	if get_progress() >= time:
		return true
	return false

func works_less_than(time : float) -> bool:
	if get_progress() < time: 
		return true
	return false

func works_between(start : float, finish : float) -> bool:
	var progress = get_progress()
	if progress >= start and progress <= finish:
		return true
	return false

func transitions_to_queued() -> bool:
	return moves_data_repo.get_transitions_to_queued(backend_animation, get_progress())

func accepts_queueing() -> bool:
	return moves_data_repo.get_accepts_queueing(backend_animation, get_progress())

func tracks_input_vector() -> bool:
	return moves_data_repo.tracks_input_vector(backend_animation, get_progress())

func time_til_unlocking() -> float:
	if tracks_input_vector():
		return 0
	return moves_data_repo.time_til_next_controllable_frame(backend_animation, get_progress())

func is_vulnerable() -> bool:
	return moves_data_repo.get_vulnerable(backend_animation, get_progress())

func is_interruptable() -> bool:
	return moves_data_repo.get_interruptable(backend_animation, get_progress())

func is_parryable() -> bool:
	return moves_data_repo.get_parryable(backend_animation, get_progress())

func get_root_position_delta(delta_time : float) -> Vector3:
	return moves_data_repo.get_root_delta_pos(backend_animation, get_progress(), delta_time)

func right_weapon_hurts() -> bool:
	return moves_data_repo.get_right_weapon_hurts(backend_animation, get_progress())

# "default-default", works for animations that just linger
func default_lifecycle(input : InputPackage):
	if works_longer_than(DURATION):
		return best_input_that_can_be_paid(input)
	return "okay"


func _on_enter_state():
	initial_position = player.global_position
	resources.pay_resource_cost(self)
	mark_enter_state()
	on_enter_state()
	animator.update_body_animations()

func on_enter_state():
	pass

func _on_exit_state():
	on_exit_state()

func on_exit_state():
	pass

func assign_combos():
	for child in get_children():
		if child is Combo:
			combos.append(child)
			child.move = self


func form_hit_data(_weapon : Weapon) -> HitData:
	print("someone tries to get hit by default Move")
	return HitData.blank()


func react_on_hit(hit : HitData):
	if not is_vulnerable():
		print("hit is here, but still the roll")
	if is_vulnerable():
		resources.lose_health(hit.damage)
	if is_interruptable():
		# TODO rewrite for better effects processing, this scales badly
		if hit.effects.has("pushback") and hit.effects["pushback"]:
			area_awareness.last_pushback_vector = hit.effects["pushback_direction"]
			try_force_move("pushback")
		else:
			try_force_move("staggered")


func react_on_parry(_hit : HitData):
	try_force_move("parried")


func try_force_move(new_forced_move : String):
	if not has_forced_move:
		has_forced_move = true
		forced_move = new_forced_move
	elif container.moves[new_forced_move].priority >= container.moves[forced_move].priority:
		forced_move = new_forced_move
