extends Button

@onready var encyclopedia_cont := %encyclopedia
@onready var main_ui := %default
@onready var player := get_tree().get_first_node_in_group('player')


func _pressed() -> void:
	encyclopedia_cont.visible = false
	main_ui.visible = true
	player.can_move = true
