extends Button

@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')
@onready var player := get_tree().get_first_node_in_group('player')
@onready var quests_cont := get_tree().get_first_node_in_group('quests')

func _pressed() -> void:
	var npc_name = get_parent().find_child("Label").text
	
	player.completion_status.remove_at(player.active_quests.find(npc_name))
	player.active_quests.erase(npc_name)
	
	MultiplayerClient.remove_quest(npc_name)
	quests_cont.change_quests.emit()
