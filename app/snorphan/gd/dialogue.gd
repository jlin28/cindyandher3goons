extends MarginContainer

@onready var npc_name_label := %name 
@onready var dialogue_box := %dialogue
@onready var option_cont := %optionscont
@onready var options := option_cont.get_children()
@onready var next_button := %next

@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')
@onready var player := get_tree().get_first_node_in_group('player')
@onready var quests_cont := get_tree().get_first_node_in_group('quests')

@export var current_dialogue_line = null
@export var current_dialogue = null
@export var current_dialogue_type = ''
@export var current_npc = null

var quest_status = null

func _set_npc_name(npc_name):
	npc_name_label.text = "< %s >" %npc_name
	current_npc = npc_name
	request_dialogue(npc_name)

func request_dialogue(npc_name):
	MultiplayerClient.retrieve_dialogue(npc_name)
	
func receive_dialogue(dg):
	current_dialogue = dg
	play_dialogue()

var tween;
func play_dialogue():
	if not current_dialogue_line:
		current_dialogue_line = quest_status
	
	if current_npc in player.active_quests:
		var quest = quests_cont.current_quests[current_npc]
		if player.completion_status[player.active_quests.find(current_npc)] == 1:
			var item_to_be_taken = quest.get('fulfillment_requirement')
			var amount_to_be_taken = quest.get('amount_required')
			var current_amount = 1.0;
			if item_to_be_taken != "house": # For Town Chief's quest
				current_amount = player.current_items[item_to_be_taken]
			if player.full_inventory and current_amount - amount_to_be_taken != 0:
				current_dialogue_line = 'item_cap'
			else:
				current_dialogue_line = 'quest_completed'
			
				player.completion_status.remove_at(player.active_quests.find(current_npc))
				player.active_quests.erase(current_npc)
				add_quest_to_completed(current_npc)
				
				MultiplayerClient.remove_item(item_to_be_taken, amount_to_be_taken)
				player.inventory_update.emit()
				
				MultiplayerClient.add_item(quest.get('reward'), quest.get('reward_amt'))
				quests_cont.change_quests.emit()
		else:
			current_dialogue_line = 'quest_in_progress'
	else:
		if 'dialogue_type' in current_dialogue[current_dialogue_line]:
			current_dialogue_type = current_dialogue[current_dialogue_line].dialogue_type
			
			if current_dialogue_type == 'quest':
				if player.active_quests.size() == 3:
					current_dialogue_line = 'quest_cap'
				else:
					player.active_quests.append(current_npc)
					player.completion_status.append(0)
					MultiplayerClient.add_quest(current_npc)
		
	dialogue_box.text = current_dialogue[current_dialogue_line].dialogue
	dialogue_box.visible_characters = 0
	tween = create_tween()
	tween.tween_property(dialogue_box, "visible_characters", dialogue_box.text.length(), 2.0)
	tween.finished.connect(tween_finished)
	
	var dialogue_options = current_dialogue[current_dialogue_line].dialogue_options
	if dialogue_options.size() > 0:
		for option in options:
			option.visible = false
		
		next_button.visible = false
	else:
		option_cont.visible = false
		next_button.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and tween:
		tween.kill()
		tween_finished()
		tween = null;
		dialogue_box.visible_characters = -1

func tween_finished():
	var i = 0;
	if current_dialogue:
		var dialogue_line = current_dialogue[current_dialogue_line]
		var dialogue_options = dialogue_line.dialogue_options
		for dialogue_option in dialogue_options:
			options[i].text = dialogue_option
			options[i].visible = true
			i+=1

func add_quest_to_completed(npc):
	MultiplayerClient.complete_quest(npc)
