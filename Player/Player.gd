extends CharacterBody3D


@onready var input_gatherer = $Input as InputGatherer
@onready var model = $Model as PlayerModel


func _physics_process(delta):
	var input = input_gatherer.gather_input()
	model.update(input, delta)
	
	# Visuals -> follow parent transformations

