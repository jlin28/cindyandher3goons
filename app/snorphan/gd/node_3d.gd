extends Node3D

@onready var player:= %player
@onready var ui := $main/Control
const Snowball:= preload("res://tscn/snowball.tscn")
const Snowman:= preload("res://tscn/snowman.tscn")

@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')
@onready var quests_cont := get_tree().get_first_node_in_group('quests')

@export var snowman_accessories = ['button', 'carrot', 'hat', 'red_scarf']

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("build_snowman") and player.current_held_item:
		if 'snowball' in player.current_held_item:
			if player.snowman_in_vicinity:
				var snowman = player.snowman_in_vicinity
				if snowman.can_build:
					if !snowman.build(player.current_held_item):
						player.update_notification("Let's try a different snowball...")
					else:
						MultiplayerClient.remove_item(player.current_held_item, 1)
						MultiplayerClient.update_snowman(player.current_held_item, snowman.id.text)
				else:
					player.update_notification("He could use some accessories!")
			elif 'L' not in player.current_held_item:
				player.update_notification("Large snowball required")
			else:
				var snowman = Snowman.instantiate()
				MultiplayerClient.remove_item(player.current_held_item, 1)
				
				get_tree().current_scene.add_child(snowman)
				snowman.position = player.position - 2.5*Vector3(sin(player.current_angle), 0, cos(player.current_angle))
				snowman.rotation.y = -player.rotation.y
				
				MultiplayerClient.create_snowman(snowman.position, snowman.rotation.y, snowman.id.text)
		elif 'stick' in player.current_held_item:
			if player.snowman_in_vicinity:
				var snowman = player.snowman_in_vicinity
				if snowman.torso_in_place:
					if !snowman.arms():
						player.update_notification("That's enough arms...")
					else:
						MultiplayerClient.remove_item(player.current_held_item, 1)
						MultiplayerClient.update_snowman(player.current_held_item, snowman.id.text)
				else:
					player.update_notification("What if we give him a body first?")
		elif 'pebbles' in player.current_held_item:
			if player.snowman_in_vicinity:
				var snowman = player.snowman_in_vicinity
				if snowman.head_in_place:
					if !snowman.pebble():
						player.update_notification("Their face can't take anymore pebbles!!")
					else:
						MultiplayerClient.remove_item(player.current_held_item, 1)
						MultiplayerClient.update_snowman(player.current_held_item, snowman.id.text)
				else:
					player.update_notification("There's no head...")
		elif player.current_held_item in snowman_accessories:
			if player.snowman_in_vicinity:
				var snowman = player.snowman_in_vicinity
				if player.current_held_item == "button":
					if snowman.torso_in_place:
						if !snowman.accessories(player.current_held_item):
							player.update_notification("Let's try something else for a change!")
						else:
							MultiplayerClient.remove_item(player.current_held_item, 1)
							MultiplayerClient.update_snowman(player.current_held_item, snowman.id.text)
					else:
						player.update_notification("What if we give him a body first?")
				elif snowman.head_in_place:
					if !snowman.accessories(player.current_held_item):
						player.update_notification("Let's try something else for a change!")
					else:
						MultiplayerClient.remove_item(player.current_held_item, 1)
						MultiplayerClient.update_snowman(player.current_held_item, snowman.id.text)
				else:
					player.update_notification("There's no head...")
							
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
			if 'snowball' not in player.current_interactable_item.label: 
				quests_cont.update_quests_progress()

	if Input.is_action_just_pressed("roll_snowball") and player.is_on_floor():
		var snowball = Snowball.instantiate()
		snowball.scale = Vector3(1,1,1)
	
		get_tree().current_scene.add_child(snowball)
		snowball.position = player.position - Vector3(sin(player.current_angle), 0, cos(player.current_angle))
	
	if Input.is_action_just_pressed("equip") and player.current_held_item and "cape" in player.current_held_item:
		player.equipped_cape = true
		MultiplayerClient.remove_item(player.current_held_item, 1)
		MultiplayerClient.update_cape_status()

func instantiate_snowmen(snowmen):
	if snowmen.size() > 0:
		for id in snowmen:
			var data = snowmen.get(id)
			var snowman = Snowman.instantiate()
				
			get_tree().current_scene.add_child(snowman)
			
			var x = float(data.get('x_coord', 0))
			var y = float(data.get('y_coord', 0))
			var z = float(data.get('z_coord', 0))
			
			snowman.position = Vector3(x, y, z)
			snowman.rotation.y = float(data.get('y_rot', 0))
			
			snowman.set_up(data)
