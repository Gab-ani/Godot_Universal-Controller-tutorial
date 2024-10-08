extends Node3D
class_name Targetable

@export var parent : Node3D

@onready var look_at_point = $LookAt

func _ready():
	if parent.is_enemy:
		add_to_group("targetable")
