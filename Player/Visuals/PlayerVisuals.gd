extends Node3D
class_name PlayerVisuals

@onready var model : PlayerModel

@onready var beta_joints = $Beta_Joints
@onready var beta_surface = $Beta_Surface

@onready var sword_visuals_1 = $SwordVisuals1

func accept_model(_model : PlayerModel):
	model = _model
	beta_surface.skeleton = _model.skeleton.get_path()
	beta_joints.skeleton = _model.skeleton.get_path()


func _process(_delta):
	adjust_weapon_visuals()


func adjust_weapon_visuals():
	sword_visuals_1.global_transform = model.active_weapon.global_transform






