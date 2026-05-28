extends Node3D

@export var stick_mesh = preload("res://tscn/stick.tscn")
@onready var plane_size = %stick_plane.mesh.size
@export var stick_count := 200

func _ready():
	for i in range(stick_count):
		spawn_stick()

func spawn_stick():
	var x = randf_range(-plane_size.x, plane_size.x)
	var z = randf_range(-plane_size.y, plane_size.y)

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(Vector3(x, 200, z), Vector3(x, -200, z))
	var result = space_state.intersect_ray(query)

	if result:
		var stick = stick_mesh.instantiate()
		stick.position = result.position
		stick.position.y += 0.2
		stick.rotation_degrees.x = 90
		stick.rotation_degrees.y = randi_range(0, 180)
		add_child(stick)
		#print("added stick at ", x, ", ", z)
