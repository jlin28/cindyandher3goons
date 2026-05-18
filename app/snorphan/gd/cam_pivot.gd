extends Node3D

@export var mouse_sensitivity:= 0.005
@export var facing = Vector3.ZERO

func _ready() -> void:
	# mouse starts off visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# unhandled inputs are basically whatever isnt handled (like what the name suggests)
func _unhandled_input(event: InputEvent) -> void:
	# should maybe fix the browser's NotAllowedError
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		print("cam_pivot.gd: Captured")

	if event is InputEventMouseMotion:
		# for some reason relative's x and y are flipped and mouse has no access to global axes sigh
		rotation.y -= event.relative.x * mouse_sensitivity
		
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clampf(rotation.x, -deg_to_rad(90), deg_to_rad(90))
		
		facing = rotation
	
	elif Input.is_action_pressed("mouse_mode"):
		print("Esc Pressed")
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			print("cam_pivot: captured -> visible")
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			print("cam_pivot: visible -> captured")
