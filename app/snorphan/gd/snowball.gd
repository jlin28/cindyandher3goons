class_name Snowball extends RigidBody3D

@onready var collision_shape = $CollisionShape3D
@onready var mesh = $MeshInstance3D

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 5;
	continuous_cd = true
	

func _physics_process(delta: float) -> void:
	freeze = false
	
	var space_state = get_world_3d().direct_space_state

	var origin = global_position
	var target = origin + Vector3.DOWN * 0.5

	var query = PhysicsRayQueryParameters3D.create(origin, target)
	query.exclude = [self]

	var result = space_state.intersect_ray(query)
	var on_floor = false;
	
	#push stuff-----------------------------------------
	var pushed = false
	
	var direction = Vector3.ZERO
	for i in range(8):
		var angle = i * (PI * 2.0 / 8)
		var target_direction = Vector3(sin(angle), 0, cos(angle)).normalized()
		var push_query = PhysicsRayQueryParameters3D.create(origin, origin + target_direction*1.2)
		push_query.exclude = [self]
		
		var push_result = space_state.intersect_ray(push_query)
		if push_result:
			direction += target_direction
			if !pushed: pushed = true
		
	if result and result.collider.is_in_group("floor"):
		on_floor = true
		
	if pushed and direction != Vector3.ZERO:
		direction = direction.normalized()
		apply_central_force(-direction * 13 * mesh.scale.x)
		
		mesh.scale *= 1.002
	elif on_floor:
		freeze = true
		
	# snowball grows when moving on ground but grows less the larger it gets
	# scale limit is disabled for now because big balls are cool
	var growth_speed := linear_velocity.length() / 15
	#const max_scale := 15
	
	var can_grow := true #scale.length() < max_scale
	var is_on_ground := get_contact_count() > 0
	
	if can_grow and is_on_ground:
		scale += Vector3(1,1,1) * growth_speed * delta
