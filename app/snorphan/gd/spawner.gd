extends Node3D

@export var stick_mesh = preload("res://tscn/stick.tscn")
@export var pebble_mesh = preload("res://tscn/pebble.tscn")
@export var special_powder_mesh = preload("res://tscn/special_powder.tscn")
@export var apple_mesh = preload("res://tscn/apples.tscn")
@export var flower_mesh = preload("res://tscn/flowers.tscn")

@onready var plane_size = %spawner_plane.mesh.size

@export var stick_count := 25
@export var pebble_count := 100
@export var powder_count := 1
@export var flower_count := 15
@export var apple_count := 55

func _ready():
	for i in range(stick_count):
		spawn("stick", randf_range(-plane_size.x/2, plane_size.x/2), randf_range(-plane_size.x/2, plane_size.x/2))
	for i in range(pebble_count):
		spawn("pebble", randf_range(-plane_size.x/2, plane_size.x/2), randf_range(-plane_size.x/2, plane_size.x/2))
	for i in range(powder_count):
		spawn("special_powder", 72.91, 281.5)
	for i in range(apple_count):
		spawn("apple", randf_range(-40, -50), randf_range(140, 170))
	for i in range(flower_count):
		spawn("flower", randf_range(370, 380), randf_range(-70, -65)) #375 35 -67

func spawn(item, x, z):
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
		if item == "special_powder":
			var special_powder = special_powder_mesh.instantiate()
			special_powder.position = result.position
			special_powder.position.y += 0.5
			add_child(special_powder)
		if item == "apple":
			var apple = apple_mesh.instantiate()
			apple.scale = Vector3.ONE * 0.5
			apple.position = result.position
			apple.position.y += 0.5
			add_child(apple)
		if item == "flower":
			var flower = flower_mesh.instantiate()
			flower.position = result.position
			flower.position.y += 0.5
			add_child(flower)
