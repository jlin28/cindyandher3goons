extends Node3D

# NOTE: MOUSE_MODE_CONFINED is used whenever a player is in dialogue
# 		MOUSE_MODE_CAPTURED is for regular gameplay
# 		MOUSE_MODE_VISIBLE is when the player presses esc or when they're first tabbing in
@onready var dialogue := get_tree().get_first_node_in_group('dialogue')

@export var mouse_sensitivity:= 0.005
@export var facing = Vector3.ZERO

@onready var player := get_tree().get_first_node_in_group('player')

func _ready() -> void:
	# mouse starts off visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# unhandled inputs are basically whatever isnt handled (like what the name suggests)
func _unhandled_input(event: InputEvent) -> void:
	# should maybe fix the browser's NotAllowedError
	if event is InputEventMouseButton and event.pressed and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE and player.can_move:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		print("cam_pivot.gd: Captured")

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# for some reason relative's x and y are flipped and mouse has no access to global axes sigh
		rotation.y -= event.relative.x * mouse_sensitivity

		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clampf(rotation.x, -deg_to_rad(90), deg_to_rad(90))

		facing = rotation

	elif Input.is_action_pressed("mouse_mode"):
		print("Esc Pressed")
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED or Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			print("cam_pivot: captured/confined -> visible")
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			print("cam_pivot: visible -> captured")
