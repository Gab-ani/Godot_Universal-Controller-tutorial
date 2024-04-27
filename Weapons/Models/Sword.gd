extends Weapon
class_name Sword


func _ready():
	base_damage = 10
	basic_attacks = {
		"light_attack_pressed" : "slash_1"
	}


func get_hit_data():
	return holder.current_move.form_hit_data(self)
