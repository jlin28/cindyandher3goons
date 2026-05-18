extends CharacterBody3D

@onready var interactable_notification := $Label3D
@onready var interactable_area := $Area3D

func _ready() -> void:
	interactable_area.body_entered.connect(_on_entered)
	interactable_area.body_exited.connect(_on_exit)
	
func _process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state

	var origin = global_position
	
	if interactable_notification.visible:
		var direction = Vector3.ZERO
		for i in range(30):
			var angle = i * (PI * 2.0 / 30)
			var target_direction = Vector3(sin(angle), 0, cos(angle)).normalized()

			var query = PhysicsRayQueryParameters3D.create(origin, origin + target_direction *5)
			query.exclude = [self]

			var result = space_state.intersect_ray(query)

			if !result.is_empty() and result.collider.is_in_group('player'):
				rotation.y = angle
	else: 
		rotation.y = 0
func _on_entered(body):
	if body.is_in_group('player'):
		interactable_notification.visible = true

func _on_exit(body):
	if body.is_in_group('player'):
		interactable_notification.visible = false
