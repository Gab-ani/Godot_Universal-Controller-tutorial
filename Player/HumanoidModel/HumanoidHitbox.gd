extends Area3D

@onready var model = $"../.." as PlayerModel


func _ready():
	area_entered.connect(on_contact)


func on_contact(area : Node3D):
	if is_eligible_attacking_weapon(area):
		area.hitbox_ignore_list.append(self)
		model.current_move.react_on_hit(area.get_hit_data())


func is_eligible_attacking_weapon(area : Node3D) -> bool:
	if area is Weapon and area != model.active_weapon and not area.hitbox_ignore_list.has(self) and area.is_attacking:
		return true
	return false
