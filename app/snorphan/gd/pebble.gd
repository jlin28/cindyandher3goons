extends RigidBody3D

@onready var collision_shape = $CollisionShape3D
@onready var mesh = $MeshInstance3D
@onready var interactable_area := $Area3D
@onready var interactable_notification := $Node3D

var label = 'pebbles'

func _ready() -> void:
	interactable_notification.visible = false
	
	interactable_area.body_entered.connect(_on_entered)
	interactable_area.body_exited.connect(_on_exit)	
	
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
