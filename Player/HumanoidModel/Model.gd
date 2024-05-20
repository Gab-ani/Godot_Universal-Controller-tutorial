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

@onready var current_move : Move
@onready var moves_container : HumanoidStates = $States


func _ready():
	moves_container.humanoid = player
	moves_container.accept_moves()
	current_move = moves_container.moves["idle"]


func update(input : InputPackage, delta : float):
	input = combat.contextualize(input)
	var relevance = current_move.check_relevance(input)
	if relevance != "okay":
		switch_to(relevance)
	#print(current_move.animation)
	current_move.update_resources(delta)
	current_move.update(input, delta)


func switch_to(state : String):
	if not is_enemy:
		print(current_move.move_name + " -> " + state)
	current_move.on_exit_state()
	current_move = moves_container.moves[state]
	current_move.on_enter_state()
	current_move.mark_enter_state()
	resources.pay_resource_cost(current_move)
	animator.play(current_move.animation)
