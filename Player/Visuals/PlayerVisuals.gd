extends Node3D
class_name PlayerVisuals

@export var beta_joints:MeshInstance3D
@export var beta_surface:MeshInstance3D

@export var sword_visuals_1:Node3D
@export var stamina_label:Label
@export var health_label:Label

var model : PlayerModel


func accept_model(_model : PlayerModel):
	model = _model
	beta_surface.skeleton = _model.skeleton.get_path()
	beta_joints.skeleton = _model.skeleton.get_path()


func _process(_delta):
	update_resources_interface()
	adjust_weapon_visuals()


func adjust_weapon_visuals():
	sword_visuals_1.global_transform = model.active_weapon.global_transform


func update_resources_interface():
	if stamina_label != null:
		stamina_label.text = "Stamina " + "%10.3f" % model.resources.stamina
	
	if health_label != null:
		health_label.text = "Health " + "%10.3f" % model.resources.health



