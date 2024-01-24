extends Node2D
class_name Controller

func _ready():
	pass

func _process(_delta):
	pass

func _input(event):
	$Camera.handle_camera_zoom(event)
	$Camera.handle_camera_pan(event)
	$Camera.handle_camera_roll(event)
