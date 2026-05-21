extends Button

@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')

func _pressed() -> void:
	MultiplayerClient.logout()
