extends Node
class_name AreaAwareness

var last_pushback_vector : Vector3
var last_input_package : InputPackage

@onready var downcast = $Downcast as RayCast3D

func get_floor_distance() -> float:
	if downcast.is_colliding():
		return downcast.global_position.distance_to(downcast.get_collision_point())
	return 999999
