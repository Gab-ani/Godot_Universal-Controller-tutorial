extends Node
class_name Move

var player : CharacterBody3D
var resources : HumanoidResources

# unique fields to redefine
@export var animation : String
@export var backend_animation : String
@export var animator : AnimationPlayer

# I can tolerate up to two _costs, 
# the moment I need a third one, I'll create a small ResourceCost class to pay them.
@export var stamina_cost : float = 0

# general fields for internal usage
@onready var combos : Array[Combo] 

var enter_state_time : float

var has_queued_move : bool = false
var queued_move : String = "none, drop error please"

var has_forced_move : bool = false
var forced_move : String = "none, drop error please"

## parameters windows incorporation way N2
# here and below in methods because I chose this way
var moves_data_repo : MovesDataRepository


## parameters windows incorporation way N1
#const default_window_length = 3
#@export_group("vulnerability")
#var is_invulnerable : bool = false
#@export_range(0, default_animation_length, 0.01, "or_greater") var invulnerability_start : float = 0
#@export_range(0, default_animation_length, 0.01,"or_greater") var invulnerability_end : float = 0
# then implement short getters for your parameters
#func is_vulnerable() -> bool:
#if works_between(invulnerability_start, invulnerability_end):
#	return false
#return true


static var moves_priority : Dictionary = {
	"idle" : 1,
	"run" : 2,
	"sprint" : 3,
	"jump_run" : 10,
	"midair" : 10,
	"landing_run" : 10,
	"jump_sprint" : 10,
	"landing_sprint" : 10,
	"slash_1" : 15,
	"slash_2" : 15,
	"slash_3" : 15,
	"parry" : 20,
	"ripost" : 25,
	"parried" : 100,
	"staggered" : 100,
	"death" : 200
}


static func moves_priority_sort(a : String, b : String):
	if moves_priority[a] > moves_priority[b]:
		return true
	else:
		return false


func check_relevance(input : InputPackage) -> String:
	if has_forced_move:
		has_forced_move = false
		return forced_move
	
	check_combos(input) # if resources want to deny something
	
	return default_lifecycle(input)  # if resources want to deny something again


func check_combos(input : InputPackage):
	for combo : Combo in combos:
		if combo.is_triggered(input) and resources.can_be_paid(player.model.moves[combo.triggered_move]):
			has_queued_move = true
			queued_move = combo.triggered_move


func best_input_that_can_be_paid(input : InputPackage) -> String:
	input.actions.sort_custom(moves_priority_sort)
	for action in input.actions:
		if resources.can_be_paid(player.model.moves[action]):
			if player.model.moves[action] == self:
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


func is_vulnerable() -> bool:
	return moves_data_repo.get_vulnerable(backend_animation, get_progress())

func is_interruptable() -> bool:
	return moves_data_repo.get_interruptable(backend_animation, get_progress())

func is_parryable() -> bool:
	return moves_data_repo.get_parryable(backend_animation, get_progress())


func default_lifecycle(_input : InputPackage) -> String:
	#can return idle, but I want this error to be thrown to make me-from-the-future's life easier
	return "implement default lyfecycle pepega " + animation

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
	has_forced_move = true
	forced_move = "parried"


func try_force_move(new_forced_move : String):
	if not has_forced_move:
		has_forced_move = true
		forced_move = new_forced_move
	elif moves_priority[new_forced_move] >= moves_priority[forced_move]:
		forced_move = new_forced_move
