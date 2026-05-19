extends MarginContainer

@onready var npc_name_label := %name 
@onready var dialogue_box := %dialogue
@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')

var current_dialogue_line = null

func _set_npc_name(npc_name):
	npc_name_label.text = "< %s >" %npc_name
	_play_dialogue(npc_name)

func _play_dialogue(npc_name):
	MultiplayerClient.retrieve_dialogue(npc_name)
	
func apply_dialogue(dg):
	if not current_dialogue_line:
		current_dialogue_line = 'A'
	
	dialogue_box.text = dg[current_dialogue_line].dialogue
