extends MarginContainer

@onready var npc_name_label = %name 

func _set_npc_name(npc_name):
	npc_name_label.text = npc_name
