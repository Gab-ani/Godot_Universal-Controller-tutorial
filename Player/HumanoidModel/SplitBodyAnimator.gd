extends Node
class_name SplitBodyAnimator

@onready var torso_animator = $Torso
@onready var legs_animator = $Legs

@export var model : PlayerModel
@export var skeleton : Skeleton3D #MixamoSkeleton
var full_body_mode : bool = true

var synchronization_delta = 0.01


func update_body_animations():
	update_playmode()
	set_animations()


func update_legs_animation():
	update_playmode()
	#set_animations()
	set_legs_animation(model.legs.current_legs_move.animation)


func set_animations():
	if full_body_mode:
		set_legs_animation(model.current_move.animation)
		set_torso_animation(model.current_move.animation)
		synchronize_if_needed()
		#if legs_animator.current_animation != model.current_move.animation + "_legs":
			#set_legs_animation(model.current_move.animation)
			#set_torso_animation(model.current_move.animation)
			#synchronize_if_needed()
	else:
		set_legs_animation(model.legs.current_legs_move.animation)
		set_torso_animation(model.current_move.animation)
		#if legs_animator.current_animation != model.legs.current_legs_move.animation + "_legs":
			#set_legs_animation(model.legs.current_legs_move.animation)
		#if torso_animator.current_animation != model.current_move.animation + "_torso":
			#set_torso_animation(model.current_move.animation)


func set_legs_animation(animation : String):
	#print(legs_animator.current_animation + " changing to " + animation + "_legs")
	legs_animator.play(animation + "_legs")


func set_torso_animation(animation : String):
	#print(torso_animator.current_animation + " changing to " + animation + "_torso")
	torso_animator.play(animation + "_torso")

# This triggers at the moments of first animation change after exiting TorsoPartialMove.
# Imagine we had running legs with 0.5 sec progress, and now we need to Run with full body.
# without this method, torso will start to animate Run from the animation start and will be
# desynced with legs, which will cause gibberish animation
func synchronize_if_needed():
	if abs(torso_animator.current_animation_position - legs_animator.current_animation_position) > synchronization_delta:
		#print("triggered synchronization")
		torso_animator.seek(legs_animator.current_animation_position)


func update_playmode():
	if model.current_move is TorsoPartialMove:
		full_body_mode = false
	if not model.current_move is TorsoPartialMove:
		full_body_mode = true


func set_speed_scale(speed : float):
	legs_animator.speed_scale = speed
	torso_animator.speed_scale = speed


func reset_torso_animation():
	torso_animator.seek(0)

func reset_legs_animation():
	legs_animator.seek(0)
