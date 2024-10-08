extends Area3D
class_name Hurtbox

# old way from controller series, works only for a player
#@onready var model = $"../.." as PlayerModel

# new way for enemies series, now lacks strict typing,
# but works now with anything that has a current_move with .react_on_hit() method, makeshift interface if you will
@export var processor : Node

# new way of defining allied weapons to not trigger on owned weapon etc.
@export var ignored_weapon_groups : Array[String]


func _physics_process(_delta):
	if has_overlapping_areas():
		for area in get_overlapping_areas():
			on_area_contact(area)


func on_area_contact(area : Node3D):
	#print(area.name)
	if is_eligible_attacking_weapon(area):
		area.hitbox_ignore_list.append(self)
		processor.current_move.react_on_hit(area.get_hit_data())


func is_eligible_attacking_weapon(area : Node3D) -> bool:
	if area is Weapon and is_not_ignored(area) and not area.hitbox_ignore_list.has(self) and area.is_attacking:
		return true
	return false



func is_not_ignored(area : Node3D) -> bool:
	for group in ignored_weapon_groups:
		if area.is_in_group(group):
			return false
	return true
