extends Node


@export var mode : String = "spamming hits"

const hits_period : float = 2
var hit_treshold : float = 0

# all this is extremely fast-written garbage to prototype enemy in 30 seconds, 
# for the love of god don't repeat this approach
func create_input(delta) -> InputPackage:
	if mode == "spamming hits":
		var new_enemy_input = InputPackage.new()
		new_enemy_input.actions.append("idle")
		hit_treshold += delta
		if hit_treshold >= hits_period:
			new_enemy_input.combat_actions.append("light_attack_pressed")
			hit_treshold -= hits_period
		return new_enemy_input
	elif mode == "spamming parry":
		var new_enemy_input = InputPackage.new()
		new_enemy_input.actions.append("idle")
		hit_treshold += delta
		if hit_treshold >= hits_period:
			new_enemy_input.actions.append("parry")
			hit_treshold -= hits_period
		return new_enemy_input
	else:
		print("your enemies are not working properly and the worst of them is you yourself")
		return null
