extends AnimationPlayer


func _ready():
	configure_blending_times()


func configure_blending_times():
	set_blend_time("run", "jump_run", 0.5)
	set_blend_time("landing_run", "run", 0.5)
	set_blend_time("jump_sprint", "midair", 0.5)
	set_blend_time("landing_run", "sprint", 0.3)
	set_blend_time("landing_sprint", "run", 0.3)
	set_blend_time("idle", "slash_1", 0.5)
	set_blend_time("idle", "parry", 0.3)
	set_blend_time("parry", "idle", 0.3)

