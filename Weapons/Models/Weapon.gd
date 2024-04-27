extends Area3D
class_name Weapon

var hitbox_ignore_list : Array[Area3D]
var is_attacking : bool = false

@export var holder : PlayerModel

@export var base_damage : float = 10

var basic_attacks : Dictionary


func get_hit_data() -> HitData:
	print("someone tries to get hit by default Weapon")
	return HitData.blank()
