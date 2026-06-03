extends Area3D

func _ready() -> void:
	body_entered.connect(_on_collision)

func _on_collision(body):
	if body.is_in_group('player'):
		body.global_position = Vector3(44.99, -16.9,103.2)
