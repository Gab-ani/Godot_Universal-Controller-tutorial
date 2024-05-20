extends AnimationPlayer


func _ready():
	configure_blending_times()


func configure_blending_times():
	set_blend_time("idle_longsword", "run", 0.3)
	set_blend_time("landing_run", "run", 0.5)
	set_blend_time("jump_sprint", "midair", 0.5)
	set_blend_time("landing_run", "sprint", 0.3)
	set_blend_time("landing_sprint", "run", 0.3)
	set_blend_time("idle", "longsword_1", 0.5)
	set_blend_time("idle", "parry", 0.3)
	set_blend_time("parry", "idle", 0.3)
	set_blend_time("longsword_1", "idle_longsword", 0.8)
	set_blend_time("longsword_1", "run", 0.3)
	set_blend_time("longsword_1", "sprint", 0.3)
	set_blend_time("longsword_1", "longsword_2", 0.3)
