extends Node
class_name Move

var humanoid : CharacterBody3D
var animator : AnimationPlayer
var resources : HumanoidResources
var combat : HumanoidCombat
var moves_data_repo : MovesDataRepository
var container : HumanoidStates


@export var animation : String
@export var move_name : String
@export var priority : int
@export var backend_animation : String

# I can tolerate up to two _costs, 
# the moment I need a third one, I'll create a small ResourceCost class to pay them.
@export var stamina_cost : float = 0

@onready var combos : Array[Combo] 

var enter_state_time : float

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


func update(_input : InputPackage, _delta : float):
	pass

func on_enter_state():
	pass

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
	if is_vulnerable():
		resources.lose_health(hit.damage)
	if is_interruptable():
		try_force_move("staggered")
	hit.queue_free()


func react_on_parry(_hit : HitData):
	try_force_move("parried")


func try_force_move(new_forced_move : String):
	if not has_forced_move:
		has_forced_move = true
		forced_move = new_forced_move
	elif container.moves[new_forced_move].priority >= container.moves[forced_move].priority:
		forced_move = new_forced_move
