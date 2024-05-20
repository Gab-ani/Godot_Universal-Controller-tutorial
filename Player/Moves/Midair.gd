extends Move

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var downcast = $"../../Downcast"
@onready var root_attachment = $"../../Root"


var landing_height : float = 1.163


func default_lifecycle(_input : InputPackage):
	var floor_point = downcast.get_collision_point()
	if root_attachment.global_position.distance_to(floor_point) < landing_height:
		var xz_velocity = humanoid.velocity
		xz_velocity.y = 0
		if xz_velocity.length_squared() >= 10:
			return "landing_sprint"
		return "landing_run"
	else:
		return "okay"


func update(_input : InputPackage, delta ):
	humanoid.velocity.y -= gravity * delta
	humanoid.move_and_slide()
