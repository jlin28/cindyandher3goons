extends MarginContainer

@onready var npc_name_label := %name 
@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')

func _set_npc_name(npc_name):
	npc_name_label.text = "< %s >" %npc_name
	_play_dialogue(npc_name)

func _play_dialogue(npc_name):
	var dg = await MultiplayerClient.retrieve_dialogue(npc_name)
	
	print(dg)
