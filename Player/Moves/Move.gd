extends Node
class_name Move

# all-move variables here
var player : CharacterBody3D

# unique fields to redefine
@export var animation : String
@export var backend_animation : String
@export var animator : AnimationPlayer

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
	"parried" : 100,
	"staggered" : 100,
}


static func moves_priority_sort(a : String, b : String):
	if moves_priority[a] > moves_priority[b]:
		return true
	else:
		return false

# There is a wall of text as a general guide on this function in the end of the page, 
# because I'm too lazy to write proper docs for a "tutorial" project
func check_relevance(input : InputPackage) -> String:
	if has_forced_move:
		has_forced_move = false
		return forced_move
	
	check_combos(input)
	return default_lifecycle(input) 


func check_combos(input : InputPackage):
	for combo : Combo in combos:
		if combo.is_triggered(input):
			has_queued_move = true
			queued_move = combo.triggered_move


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


func default_lifecycle(input : InputPackage) -> String:
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


func form_hit_data(weapon : Weapon) -> HitData:
	print("someone tries to get hit by default Move")
	return HitData.blank()


func react_on_hit(hit : HitData):
	if is_interruptable():
		has_forced_move = true
		forced_move = "staggered"

func react_on_parry(hit : HitData):
	has_forced_move = true
	forced_move = "parried"
