extends Node
class_name HumanoidResources


@export var god_mode : bool = false

@export var health : float = 100
@export var max_health : float = 100

@export var stamina : float = 100
@export var max_stamina : float = 100
@export var stamina_regeneration_rate : float = 10  # per sec, because then we'll multiply on delta

@onready var model = $".." as PlayerModel

var statuses : Array[String]
const FATIQUE_TRESHOLD = 20


func update(delta : float):
	gain_stamina(stamina_regeneration_rate * delta)


func pay_resource_cost(move : Move):
	lose_stamina(move.stamina_cost)


func can_be_paid(move : Move) -> bool:
	if stamina > 0 or move.stamina_cost == 0:
		return true
	return false

# F a part of polymorphism, it doesn't work
#func can_be_paid(move_name : String) -> bool:
	#var move = model.moves[move_name]
	#return can_be_paid(move)


func lose_health(amount : float):
	if not god_mode:
		health -= amount
		if health < 1:
			model.current_move.try_force_move("death")


func gain_health(amount : float):
	if health + amount <= max_health:
		health += amount
	else:
		health = max_health


func lose_stamina(amount : float):
	if not god_mode:
		stamina -= amount
		if stamina < 1:
			statuses.append("fatique")


func gain_stamina(amount : float):
	if stamina + amount < max_stamina:
		stamina += amount
	else:
		stamina = max_stamina
	if stamina > FATIQUE_TRESHOLD:
		statuses.erase("fatique")
