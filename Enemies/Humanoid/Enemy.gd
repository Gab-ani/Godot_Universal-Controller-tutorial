extends CharacterBody3D


@export var ai:Node
@export var model:PlayerModel
@export var visuals:PlayerVisuals


func _ready():
	visuals.accept_model(model)
	#$CameraMount/PlayerCamera.current = false
	#print_tree_pretty()


func _physics_process(delta):
	var input:InputPackage = ai.create_input(delta)
	model.update(input, delta)
	
	# Visuals -> follow parent transformations
	
