extends RigidBody3D

@onready var collision_shape = $CollisionShape3D
@onready var mesh = $MeshInstance3D

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
