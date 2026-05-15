extends CharacterBody3D

var speed = 14
var fall_acceleration = 75
var jump_velocity = 20

@onready var cam_pivot := %pivot as Node3D

func _physics_process(delta):
	var direction = Vector3.ZERO
	var rotation = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		rotation.x += deg_to_rad(90)
		
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1  # Forward is negative!
		
	if Input.is_action_pressed("move_back"):
		direction.z += 1
		
	if direction != Vector3.ZERO: 
		# look_at rotates your object so it faces a point (look_at(target_position, up_direction))
		# global_position is your character's position in the world
		# Vector3.UP gives you a point pointing upwards vs Vector3.Zero which has no direction
		var point = global_position - direction
		
		look_at(point, Vector3.UP)
		direction = direction.normalized()
	# Normalizing a vector maintains the original direction while changing the magnitute to 1.
	# This way diagonal movement isn't faster!

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if not is_on_floor():
		velocity.y -= fall_acceleration * delta
	# delta = time since last physics frame, multiplying by this makes gravity independent of frame rate
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	move_and_slide()

func _process(delta: float) -> void:
	cam_pivot.position = position
