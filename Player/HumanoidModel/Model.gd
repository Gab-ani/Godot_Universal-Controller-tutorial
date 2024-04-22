extends Node
class_name PlayerModel

@onready var player = $".."
@onready var skeleton = %GeneralSkeleton
@onready var animator = $SkeletonAnimator
@onready var combat = $Combat as HumanoidCombat

@onready var active_weapon : Weapon = $RightWrist/WeaponSocket/Sword as Sword
#@onready var weapons = {
	#"sword" = $....Sword,
	#"bow" = $....Bow,
	#"greatsword" = $....Greatsword,
	#....
#}

var current_move : Move

@onready var moves = {
	"idle" : $States/Idle,
	"run" : $States/Run,
	"sprint" : $States/Sprint,
	"jump_run" : $States/JumpRun,
	"midair" : $States/Midair,
	"landing_run" : $States/LandingRun,
	"jump_sprint" : $States/JumpSprint,
	"landing_sprint" : $States/LandingSprint,
	"slash_1" : $States/Slash1,
	"slash_2" : $States/Slash2,
	"slash_3" : $States/Slash3
}


func _ready():
	current_move = moves["idle"]
	for move in moves.values():
		move.player = player


func update(input : InputPackage, delta : float):
	input = combat.translate_combat_actions(input)
	var relevance = current_move.check_relevance(input)
	if relevance != "okay":
		switch_to(relevance)
	#print(current_move.animation)
	current_move.update(input, delta)


func switch_to(state : String):
	current_move.on_exit_state()
	current_move = moves[state]
	current_move.on_enter_state()
	current_move.mark_enter_state()
	animator.play(current_move.animation)
