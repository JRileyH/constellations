extends Camera2D

const ZOOM_INI: float = 0.5
const ZOOM_MIN: float = 0.5
const ZOOM_MAX: float = 10.0
const ZOOM_SPEED: float = 3.0
const PAN_SPEED: float = 800.0
const ROLL_SPEED: float = 3.0

var camera_zoom: Vector2 = Vector2.ZERO
var camera_pan: Vector2 = Vector2.ZERO
var camera_roll: float = 0.0

func handle_camera_zoom(e: InputEvent):
	var update: float = 0.0
	if e is InputEventPanGesture:
		update = max(min(e.delta.y, 1.0), -1.0)
	else:
		update -= Input.get_action_strength("camera_zoom_in")
		update += Input.get_action_strength("camera_zoom_out")
		update = max(min(update, 1.0), -1.0)
	camera_zoom += Vector2.ONE * update
	if camera_zoom.y <= ZOOM_MIN:
		camera_zoom = Vector2.ONE * ZOOM_MIN
	elif camera_zoom.y >= ZOOM_MAX:
		camera_zoom = Vector2.ONE * ZOOM_MAX

func handle_camera_pan(_e: InputEvent):
	var update_x: float = 0.0
	var update_y: float = 0.0
	update_y -= Input.get_action_strength("camera_pan_up")
	update_y += Input.get_action_strength("camera_pan_down")
	update_x -= Input.get_action_strength("camera_pan_left")
	update_x += Input.get_action_strength("camera_pan_right")
	camera_pan = Vector2(update_x, update_y).normalized().rotated(rotation)

func handle_camera_roll(_e: InputEvent):
	var update: float = 0.0
	update -= Input.get_action_strength("camera_roll_left")
	update += Input.get_action_strength("camera_roll_right")
	update = max(min(update, 1), -1)
	camera_roll = update

func _ready():
	camera_zoom = Vector2.ONE * ZOOM_INI
	zoom = camera_zoom

func _process(delta: float):
	get_parent().position += camera_pan * delta * PAN_SPEED
	rotation += camera_roll * delta * ROLL_SPEED
	zoom = zoom.move_toward(camera_zoom, delta * ZOOM_SPEED)
