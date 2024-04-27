extends AnimationPlayer


@export var is_parryable : bool
@export var is_vulnerable : bool
@export var is_interruptable : bool
@export var is_grabable : bool

func get_boolean_value(animation : String, track : int, timecode : float) -> bool:
	var data = get_animation(animation)
	return data.value_track_interpolate(track, timecode)
