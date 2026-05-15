extends CharacterBody3D

var speed = 14
var fall_acceleration = 75
var jump_velocity = 20

@onready var cam := %pivot

func _physics_process(delta):
	var direction = Vector3.ZERO
	var rotation = Vector3.ZERO
	var current_angle = cam.facing.y
	
	if Input.is_action_pressed("move_right"):
		direction += Vector3(cos(current_angle), 0, -sin(current_angle))
		
	if Input.is_action_pressed("move_left"):
		direction -= Vector3(cos(current_angle), 0, -sin(current_angle))
		
	if Input.is_action_pressed("move_forward"):
		direction -= Vector3(sin(current_angle), 0, cos(current_angle))  # Forward is negative!
		
	if Input.is_action_pressed("move_back"):
		direction += Vector3(sin(current_angle), 0, cos(current_angle)) 
		
	if direction != Vector3.ZERO: 
		# look_at rotates your object so it faces a point (look_at(target_position, up_direction))
		# global_position is your character's position in the world
		# Vector3.UP gives you a point pointing upwards vs Vector3.Zero which has no direction
		look_at(global_position - direction, Vector3.UP)
		
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
	cam.position = position
