extends Button

@onready var respawn_prompt := %respawn_prompt_cont
@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')

func _pressed() -> void:
	respawn_prompt.visible = false
	MultiplayerClient.local_player.global_position = Vector3(44.99, -16.9,103.2)
