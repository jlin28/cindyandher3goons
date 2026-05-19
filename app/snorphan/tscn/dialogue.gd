extends MarginContainer

@onready var npc_name_label := %name 
@onready var dialogue_box := %dialogue
@onready var option_cont := %optionscont
@onready var options := option_cont.get_children()
@onready var next_button := %next

@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')

@export var current_dialogue_line = null
@export var current_dialogue = null
@export var current_npc = null

func _set_npc_name(npc_name):
	npc_name_label.text = "< %s >" %npc_name
	current_npc = npc_name
	request_dialogue(npc_name)

func request_dialogue(npc_name):
	MultiplayerClient.retrieve_dialogue(npc_name)
	
func receive_dialogue(dg):
	current_dialogue = dg
	play_dialogue()
	
func play_dialogue():
	if not current_dialogue_line:
		current_dialogue_line = 'A'
	
	dialogue_box.text = current_dialogue[current_dialogue_line].dialogue
	print(current_dialogue_line)
	
	var dialogue_options = current_dialogue[current_dialogue_line].dialogue_options
	if dialogue_options.size() > 0:
		var i = 0
		for dialogue_option in dialogue_options:
			options[i].text = dialogue_option
			i+=1
		next_button.visible = false
	else:
		option_cont.visible = false
		next_button.visible = true
