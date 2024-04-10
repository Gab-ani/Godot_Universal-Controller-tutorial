extends Node
class_name PlayerModel

@onready var player = $".."

var current_move : Move

@onready var moves = {
	"idle" : $Idle,
	"run" : $Run,
	"jump" : $Jump
}


func _ready():
	current_move = moves["idle"]
	for move in moves.values():
		move.player = player


func update(input : InputPackage, delta : float):
	var relevance = current_move.check_relevance(input)
	if relevance != "okay":
		switch_to(relevance)
	current_move.update(input, delta)


func switch_to(state : String):
	current_move.on_exit_state()
	current_move = moves[state]
	current_move.on_enter_state()
