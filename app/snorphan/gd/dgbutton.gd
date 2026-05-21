extends Button

@onready var dialogue := get_tree().get_first_node_in_group('dialogue')
@onready var player := get_tree().get_first_node_in_group('player')
@onready var mainui := %default
@onready var options := %optionscont
@onready var dialogue_box := %dialogue
@onready var name_label := %name 

func _pressed() -> void:
	options.visible = true
	
	
	if name_label.text != "< %s >" %dialogue.current_npc:
		name_label.text = "< %s >" %dialogue.current_npc
		
		var cdl = dialogue.current_dialogue_line
		var cd = dialogue.current_dialogue
		dialogue.current_dialogue_line = cd[cdl].dialogue_options.get(dialogue_box.text)
		print(dialogue.current_dialogue_line)

		dialogue.play_dialogue()
	else: # this runs when the dialogue ends
		dialogue.visible = false
		mainui.visible = true
		
		player.can_move = true
		
		dialogue.current_dialogue_line = null
		dialogue.current_dialogue = null
		dialogue.current_npc = null
		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
