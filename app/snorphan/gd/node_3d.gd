extends Node3D

@export var mouse_sensitivity:= 0.005

func _ready() -> void:
	# makes mouse invisible
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# unhandled inputs are basically whatever isnt handled (like what the name suggests)
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# for some reason relative's x and y are flipped and mouse has no access to global axes sigh
		rotation.y -= event.relative.x * mouse_sensitivity
		
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clampf(rotation.x, -deg_to_rad(90), deg_to_rad(90))
