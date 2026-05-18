extends CharacterBody3D

func _process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	
	var origin = global_position
	
	for i in range(15):
		var angle = i * (PI * 2.0 / 15)
		var horizontal_target_direction = Vector3(sin(angle), 0, cos(angle)).normalized()
		var vertical_target_direction = Vector3(sin(angle), tan(angle), cos(angle)).normalized()
		
		var horizontal_query = PhysicsRayQueryParameters3D.create(origin, origin + horizontal_target_direction *5 )
		var vertical_query = PhysicsRayQueryParameters3D.create(origin, origin + vertical_target_direction * 5)
		horizontal_query.exclude = [self]
		vertical_query.exclude = [self]
		
		var horizontal_result = space_state.intersect_ray(horizontal_query)
		var vertical_result = space_state.intersect_ray(vertical_query)
		
		if !horizontal_result.is_empty() and horizontal_result.collider.is_in_group('player'):
			print('i found a player!')
		
		elif !vertical_result.is_empty() and vertical_result.collider.is_in_group('player'):
			print('i found a player!')
