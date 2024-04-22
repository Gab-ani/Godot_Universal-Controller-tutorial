extends Combo

@export var root_move : Move

@export var panic_click_block : float

@export var primary_input : String
@export var next_attack : String


func _ready():
	triggered_move = next_attack


func is_triggered(input : InputPackage):
	if input.actions.has(primary_input) and root_move.works_longer_than(panic_click_block):
		return true
	return false
