extends Node
class_name Move


# all-move variables here
var player : CharacterBody3D

# unique fields to redefine
var animation : String
var move_name : String
var has_queued_move : bool = false
var queued_move : String = "none, drop error please"

# general fields for internal usage
var enter_state_time : float


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
	"slash_3" :15
}


static func moves_priority_sort(a : String, b : String):
	if moves_priority[a] > moves_priority[b]:
		return true
	else:
		return false

# There is a wall of text as a general guide on this function in the end of the page, 
# because I'm too lazy to write proper docs for a "tutorial" project
func check_relevance(_input : InputPackage) -> String:
	print_debug("error, implement the check_relevance function on your state")
	return "error, implement the check_relevance function on your state"


func update(_input : InputPackage, _delta : float):
	pass


func on_enter_state():
	pass

func on_exit_state():
	pass


func check_combos(input : InputPackage):
	# works if only children we have are combos, use defined on ready array if not
	var available_combos = get_children()
	for combo : Combo in available_combos:
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



# General Moves heir usage guide.

# > check_relevance function aims to be short and simple.
# 	Its general structure is as follows: 
#	if (move is ready to transition) :
#		transition to the highest priority out there
#	else:
#		return "okay" to save our managing status.
#
# 	Move readyness for transition is generally a simple function based on timings or statuses of the player.
#	If you are starting to understand that your transition readyness is a complex method, OR
# 	if you are tempted to add third branching operator into your check_relevance function,
#	seriously consider if Combo can do this logic for you, you won't regret its usage I promise.
#	(Combo is clickable even from comments btw)

# > update functions manages perframe behaviour of your Move.
#	There are two update types: constant change and a single dynamic update on some timing.
#	To implement simple constant changes, try to find some physics abstraction for them to make
#	engine work for you. If your constant changes are too complex, try to avoid hardcoding 
#	the behaviour into a giant update, better shove the changes data into a backend animation or
#	some other data structure resource.
#	To implement timed changes, use a flag and work with timings via get_progress() and Co.
#	To roughly base your internal timings on the players behaviour, you can check skeleton
#	animation for reference. But for the love of god please avoid referensing skeleton and animator
#	in any shape way or form in the Moves code directly. This way your Move "backend" is free from
#	thousand different ways someone (probably you from the future) can mess up your skeleton, scene composition,
#	animations, names libraries etc.
