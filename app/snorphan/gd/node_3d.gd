extends Node3D

@onready var player:= %player
@onready var ui := $main/Control
const Snowball:= preload("res://tscn/snowball.tscn")
const Snowman:= preload("res://tscn/snowman.tscn")

@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')
@onready var quests_cont := get_tree().get_first_node_in_group('quests')

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("build_snowman"):
		if player.current_held_item and 'snowball' in player.current_held_item:
			if player.snowman_in_vicinity:
				var snowman = player.snowman_in_vicinity
				if snowman.can_build:
					if !snowman.build(player.current_held_item):
						player.update_notification("Let's try a smaller snowball...")
					else:
						print("I run")
						MultiplayerClient.remove_item(player.current_held_item, 1)
						player.inventory_update.emit()
				else:
					player.update_notification("He could use some accessories!")
			elif 'L' not in player.current_held_item:
				player.update_notification("Large snowball required")
			else:
				var snowman = Snowman.instantiate()
				MultiplayerClient.remove_item(player.current_held_item, 1)
				
				get_tree().current_scene.add_child(snowman)
				snowman.position = player.position - 2.5*Vector3(sin(player.current_angle), 0, cos(player.current_angle))
		elif player.current_held_item and 'stick' in player.current_held_item:
			if player.snowman_in_vicinity:
				var snowman = player.snowman_in_vicinity
				if snowman.torso_in_place:
					if !snowman.arms():
						player.update_notification("That's enough arms...")
		elif player.current_held_item and 'pebbles' in player.current_held_item:
			if player.snowman_in_vicinity:
				var snowman = player.snowman_in_vicinity
				if snowman.head_in_place:
					if !snowman.pebble():
						player.update_notification("That's enough arms...")
	if Input.is_action_just_pressed("interact") and player.can_move:
		if player.npc_interactable == true:
			var dialogue_box = ui.get_child(1)
			
			ui.get_child(0).visible = false
			dialogue_box.visible = true
			dialogue_box._set_npc_name(player.current_interactable_npc)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			player.can_move = false
			player.npc_interactable = false
			
			player.idle.visible = true
			player.anim_cont2.visible = false
			player.anim_cont.visible = false
		
		elif player.item_interactable == true:
			MultiplayerClient.add_item(player.current_interactable_item.label, 1)
			if 'snowball' not in player.current_interactable_item: 
				quests_cont.update_quests_progress()

	if Input.is_action_just_pressed("roll_snowball") and player.is_on_floor():
		var snowball = Snowball.instantiate()
		snowball.scale = Vector3(1,1,1)
	
		get_tree().current_scene.add_child(snowball)
		snowball.position = player.position - Vector3(sin(player.current_angle), 0, cos(player.current_angle))
