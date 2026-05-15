extends Node3D

@onready var player:= $CharacterBody3D
const Snowball:= preload("res://tscn/snowball.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		# will set up interactable groups later, for now we make snowball
		var snowball = Snowball.instantiate()
		
		get_tree().current_scene.add_child(snowball)
		snowball.position = player.position + Vector3(sin(player.current_angle), 0, cos(player.current_angle))
