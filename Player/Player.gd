extends CharacterBody3D


@export var input_gatherer:InputGatherer
@export var model:PlayerModel
@export var visuals:PlayerVisuals
@export var camera_mount:Node3D
@export var collider:CollisionShape3D


func _ready():
	visuals.accept_model(model)
	#$CameraMount/PlayerCamera.current = false
	#print_tree_pretty()


func _physics_process(delta):
	var input:InputPackage = input_gatherer.gather_input()
	model.update(input, delta)
	# Visuals -> follow parent transformations
