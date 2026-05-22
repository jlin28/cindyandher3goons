class_name Snowball extends RigidBody3D

@onready var collision_shape = $CollisionShape3D
@onready var mesh = $MeshInstance3D
@onready var interactable_area := $Area3D
@onready var interactable_notification := $Node3D

var label = 'snowball_S'

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 5;
	continuous_cd = true
	
	interactable_area.body_entered.connect(_on_entered)
	interactable_area.body_exited.connect(_on_exit)	

func _physics_process(delta: float) -> void:
	freeze = false
	
	# snowball grows when moving on ground but grows less the larger it gets
	# scale limit is disabled for now because big balls are cool
	var growth_speed := linear_velocity.length() / 15
	const max_scale := 15
	
	var can_grow := scale.length() < max_scale
	var is_on_ground := get_contact_count() > 0
	
	var space_state = get_world_3d().direct_space_state
	
	#push stuff-----------------------------------------
	var origin = global_position
	var pushed = false
	
	var direction = Vector3.ZERO
	for i in range(15):
		var angle = i * (PI * 2.0 / 15)
		var horizontal_target_direction = Vector3(sin(angle), 0, cos(angle)).normalized()
		var vertical_target_direction = Vector3(sin(angle), tan(angle), cos(angle)).normalized()

		var horizontal_query = PhysicsRayQueryParameters3D.create(origin, origin + horizontal_target_direction *3)
		var vertical_query = PhysicsRayQueryParameters3D.create(origin, origin + vertical_target_direction * 3)
		horizontal_query.exclude = [self]
		vertical_query.exclude = [self]

		var horizontal_result = space_state.intersect_ray(horizontal_query)
		var vertical_result = space_state.intersect_ray(vertical_query)

		if (!horizontal_result.is_empty() and horizontal_result.collider.is_in_group('player')) or (!vertical_result.is_empty() and vertical_result.collider.is_in_group('player')):
			direction += horizontal_target_direction
			if !pushed: pushed = true
		
	if pushed and direction != Vector3.ZERO:
		direction = direction.normalized()
		apply_central_force(-direction * 5 * mesh.scale.x)
		
		if can_grow and is_on_ground:
			scale += Vector3(1,1,1) * growth_speed * delta
			position.y += growth_speed * delta
			
			if scale.length() > 5:
				if scale.length() > 10:
					label = 'snowball_L'
				else: 
					label = 'snowball_M'
	elif is_on_ground:
		freeze = true
	
func _on_entered(body):
	if body.is_in_group('player'):
		interactable_notification.visible = true
		body.item_interactable = true
		
		body.current_interactable_item = self

func _on_exit(body):
	if body.is_in_group('player'):
		interactable_notification.visible = false
		body.item_interactable = false
		
		body.current_interactable_item = null
	
