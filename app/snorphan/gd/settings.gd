extends Button

@onready var settings_cont := %settings
@onready var main_ui := %default
@onready var player := get_tree().get_first_node_in_group('player')


func _pressed() -> void:
	settings_cont.visible = true
	main_ui.visible = false
	player.can_move = false
