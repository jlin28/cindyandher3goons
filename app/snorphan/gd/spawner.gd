extends Node3D

@export var stick_mesh = preload("res://tscn/stick.tscn")
@export var pebble_mesh = preload("res://tscn/pebble.tscn")
@onready var plane_size = %spawner_plane.mesh.size
@export var stick_count := 25
@export var pebble_count := 100

func _ready():
	for i in range(stick_count):
		spawn("stick")
	for i in range(pebble_count):
		spawn("pebble")

func spawn(item):
	var x = randf_range(-plane_size.x/2, plane_size.x/2)
	var z = randf_range(-plane_size.y/2, plane_size.y/2)

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(Vector3(x, 200, z), Vector3(x, -200, z))
	var result = space_state.intersect_ray(query)

	if result:
		if item == "stick":
			var stick = stick_mesh.instantiate()
			stick.scale = Vector3.ONE * 0.5
			stick.position = result.position
			stick.position.y += 0.5
			stick.rotation_degrees.y = randi_range(0, 180)
			add_child(stick)
		if item == "pebble":
			var pebble = pebble_mesh.instantiate()
			pebble.scale = Vector3.ONE * 0.5
			pebble.position = result.position
			pebble.position.y += 0.5
			add_child(pebble)
