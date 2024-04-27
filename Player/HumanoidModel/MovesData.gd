extends Node
class_name MovesDataRepository

@onready var move_database = $MoveDatabase


func get_vulnerable(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:is_vulnerable", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode) 

func get_interruptable(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:is_interruptable", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode) 

func get_parryable(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:is_parryable", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode)
