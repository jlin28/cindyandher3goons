extends VBoxContainer

@onready var quest_boxes := self.get_children()
@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')
@onready var player := get_tree().get_first_node_in_group('player')
@onready var go_chief_quest = get_node("/root/Node3D/buildings/house5/chief_quest_Area3D")

@export var current_quests = null

signal change_quests

func _ready() -> void:
	change_quests.connect(_on_quests_update)
	go_chief_quest.body_entered.connect(_on_chief_quest_entered)

func _on_quests_update():
	fetch_quests()

func fetch_quests():
	var quests = MultiplayerClient.fetch_quests()
	
func update_quests(active_quests):
	var i = 0
	current_quests = active_quests

	player.active_quests.clear()
	player.completion_status.clear()

	for npc_name in active_quests:
		print(npc_name)
		player.active_quests.append(npc_name)
		player.completion_status.append(0)  
		var quest = active_quests[npc_name]
		print(quest)
		var current_quest_box = quest_boxes[i]
		var info_cont = current_quest_box.get_node(^'MarginContainer/VBoxContainer')
		var second_info_cont = info_cont.get_node(^'HBoxContainer')

		info_cont.get_node(^"quest_name").text = quest.name
		info_cont.get_node(^"quest_desc").text = "- %s" % quest.desc

		if quest.type == 'fetch':
			print('here')
			update_current_progress(quest, info_cont, second_info_cont.get_node(^"HBoxContainer/quest_current_progress"))
		
		print('failed before here?')
		current_quest_box.visible = true
		i += 1

	for remaining_box in range(i, 3):
		quest_boxes[remaining_box].visible = false

func update_current_progress(quest, quest_info_cont, current_quest_progress):
	if quest.fulfillment_requirement in player.current_items:
		if quest.amount_required == player.current_items[quest.fulfillment_requirement]:
			quest_info_cont.get_node(^"quest_req").text = 'COMPLETED'
			quest_info_cont.get_node(^"quest_req").modulate = Color('#70ff83')
			
			current_quest_progress.text = ''
			quest_info_cont.get_node(^"HBoxContainer/quest_required_progress").text = ''
			
			return true
		else:
			quest_info_cont.get_node(^"quest_req").text = quest.fufillment_requirement
			quest_info_cont.get_node(^"quest_req").modulate = Color('#ffffff')
			
			current_quest_progress.text = player.current_items[quest.fulfillment_requirement]
			quest_info_cont.get_node(^"HBoxContainer/quest_required_progress").text = str(quest.amount_required)
			
			return false
			
func update_quests_progress():
	if current_quests:
		var i = 0
		for npc_name in current_quests:
			var quest = current_quests[npc_name]
			if quest.type == 'fetch':
				var current_quest_box = quest_boxes[i]
				var info_cont = current_quest_box.get_node(^'MarginContainer/VBoxContainer')
				var second_info_cont = info_cont.get_node(^'HBoxContainer')
			
				if update_current_progress(quest, info_cont, second_info_cont.get_node(^"HBoxContainer/quest_current_progress")):
					player.completion_status[i] = 1

			i += 1

func _on_chief_quest_entered(body):
	if "Town Chief" in player.active_quests:
		for i in range(len(player.active_quests)):
			var current_quest_box = quest_boxes[i]
			var info_cont = current_quest_box.get_node(^'MarginContainer/VBoxContainer')
			var second_info_cont = info_cont.get_node(^'HBoxContainer')

			second_info_cont.get_node(^"quest_req").text = 'COMPLETED'
			second_info_cont.get_node(^"quest_req").modulate = Color('#70ff83')
			player.completion_status[player.active_quests.find("Town Chief")] = 1
		
