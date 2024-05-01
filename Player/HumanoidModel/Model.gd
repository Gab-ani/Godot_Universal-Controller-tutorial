extends Node
class_name PlayerModel

@export var is_enemy : bool = false

@onready var player = $".."
@onready var skeleton = %GeneralSkeleton
@onready var animator = $SkeletonAnimator
@onready var combat = $Combat as HumanoidCombat
@onready var resources = $Resources as HumanoidResources

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
	"slash_3" : $States/Slash3,
	"staggered" : $States/Staggered,
	"parry" : $States/Parry,
	"ripost" : $States/Ripost,
	"parried" : $States/Parried,
	"death" : $States/Death,
}

func _ready():
	current_move = moves["idle"]
	for move : Move in moves.values():
		move.player = player
		move.resources = resources
		move.moves_data_repo = $MovesData
		move.assign_combos()


func update(input : InputPackage, delta : float):
	input = combat.contextualize(input)
	var relevance = current_move.check_relevance(input)
	if relevance != "okay":
		switch_to(relevance)
	#print(current_move.animation)
	current_move.update_resources(delta)
	current_move.update(input, delta)


func switch_to(state : String):
	#print("switching from " + current_move.animation + " to " + state)
	current_move.on_exit_state()
	current_move = moves[state]
	current_move.on_enter_state()
	current_move.mark_enter_state()
	resources.pay_resource_cost(current_move)
	animator.play(current_move.animation)
