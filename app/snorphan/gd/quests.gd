extends VBoxContainer

@onready var quest_boxes := self.get_children()
@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')
@onready var player := get_tree().get_first_node_in_group('player')
@onready var go_chief_quest = get_node("/root/Node3D/buildings/house5/chief_quest_Area3D")
@onready var elapsed_time = 0
@onready var buttons = false
@export var current_quests = null

signal change_quests

func _ready() -> void:
	change_quests.connect(_on_quests_update)
	go_chief_quest.body_entered.connect(_on_chief_quest_entered)

func _process(delta: float) -> void:
	if buttons:
		elapsed_time += delta
		update_quests_progress()

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
		player.active_quests.append(npc_name)
		player.completion_status.append(0)
		var quest = active_quests[npc_name]
		var current_quest_box = quest_boxes[i]
		var info_cont = current_quest_box.get_node(^'MarginContainer/VBoxContainer')
		var second_info_cont = info_cont.get_node(^'HBoxContainer')
		
		var npc_name_cont = current_quest_box.get_node(^"MarginContainer2/Label")
		npc_name_cont.text = npc_name

		info_cont.get_node(^"quest_name").text = quest.get('name')
		info_cont.get_node(^"quest_desc").text = "- %s" % quest.get('desc')

		if quest.get('type') == 'fetch':
			update_current_progress(quest, second_info_cont, second_info_cont.get_node(^"HBoxContainer/quest_current_progress"))
		if quest.get('type') == 'wait':
			buttons = true

		current_quest_box.visible = true
		i += 1

	for remaining_box in range(i, 3):
		quest_boxes[remaining_box].visible = false

func update_current_progress(quest, quest_info_cont, current_quest_progress):
	if player.current_items == null:
		return false

	var req = quest.get('fulfillment_requirement')
	var required = quest.get('amount_required')
	var current = player.current_items.get(req, 0)
	if current >= required or (buttons and elapsed_time > 10):
		buttons = false
		quest_info_cont.get_node(^"quest_req").text = 'COMPLETED'
		quest_info_cont.get_node(^"quest_req").modulate = Color('#70ff83')
		current_quest_progress.text = ''
		quest_info_cont.get_node(^"HBoxContainer/quest_required_progress").text = ''
		return true
	elif quest.get('type') == 'wait':
		quest_info_cont.get_node(^"quest_req").text = "wait for it..."
		quest_info_cont.get_node(^"quest_req").modulate = Color('#ffffff')
		current_quest_progress.text = str(int(elapsed_time))
		print(str(current) + str(required))
		quest_info_cont.get_node(^"HBoxContainer/quest_required_progress").text = '/' + str(10)
		return false
	else:
		quest_info_cont.get_node(^"quest_req").text = req.replace('_', ' ')
		quest_info_cont.get_node(^"quest_req").modulate = Color('#ffffff')
		current_quest_progress.text = str(current)
		print(str(current) + str(required))
		quest_info_cont.get_node(^"HBoxContainer/quest_required_progress").text = '/' + str(int(required))
		return false

func update_quests_progress():
	if current_quests and player.current_items != null:
		var i = 0
		for npc_name in current_quests:
			var quest = current_quests[npc_name]
			if quest.get('type') == 'fetch':
				var current_quest_box = quest_boxes[i]
				var info_cont = current_quest_box.get_node(^'MarginContainer/VBoxContainer')
				var second_info_cont = info_cont.get_node(^'HBoxContainer')

				if update_current_progress(quest, second_info_cont, second_info_cont.get_node(^"HBoxContainer/quest_current_progress")):
					player.completion_status[i] = 1
			elif quest.get('type') == 'wait':
				var current_quest_box = quest_boxes[i]
				var info_cont = current_quest_box.get_node(^'MarginContainer/VBoxContainer')
				var second_info_cont = info_cont.get_node(^'HBoxContainer')
				
				if update_current_progress(quest, second_info_cont, second_info_cont.get_node(^"HBoxContainer/quest_current_progress")):
					player.completion_status[i] = 1
			i += 1

func _on_chief_quest_entered(body):
	if body == player:
		for i in range(len(player.active_quests)):
			if player.active_quests[i] == "Town Chief":
				var current_quest_box = quest_boxes[i]
				var info_cont = current_quest_box.get_node(^'MarginContainer/VBoxContainer')
				var second_info_cont = info_cont.get_node(^'HBoxContainer')

				second_info_cont.get_node(^"quest_req").text = 'COMPLETED'
				second_info_cont.get_node(^"quest_req").modulate = Color('#70ff83')
				player.completion_status[player.active_quests.find("Town Chief")] = 1
