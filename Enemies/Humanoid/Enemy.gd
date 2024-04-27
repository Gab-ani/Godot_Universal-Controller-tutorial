extends CharacterBody3D


@onready var ai = $AI
@onready var model = $Model as PlayerModel
@onready var visuals = $Visuals as PlayerVisuals


func _ready():
	visuals.accept_model(model)
	#$CameraMount/PlayerCamera.current = false
	#print_tree_pretty()


func _physics_process(delta):
	var input = ai.create_input(delta)
	model.update(input, delta)
	
	# Visuals -> follow parent transformations
	
	input.queue_free()
