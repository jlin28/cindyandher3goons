extends Node3D

@onready var player:= %player
@onready var ui := $main/Control
const Snowball:= preload("res://tscn/snowball.tscn")

@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and player.can_move:
		if player.npc_interactable == true:
			var dialogue_box = ui.get_child(1)
			
			ui.get_child(0).visible = false
			dialogue_box.visible = true
			dialogue_box._set_npc_name(player.current_interactable_npc)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			player.can_move = false
			
			player.idle.visible = true
			player.anim_cont2.visible = false
			player.anim_cont.visible = false
		
		elif player.item_interactable == true:
			MultiplayerClient.add_item(player.current_interactable_item.label, 1)
			
			player.current_interactable_item.queue_free()
			player.inventory_update.emit()

		elif player.is_on_floor():
			var snowball = Snowball.instantiate()
			snowball.scale = Vector3(1,1,1)
		
			get_tree().current_scene.add_child(snowball)
			snowball.position = player.position - Vector3(sin(player.current_angle), 0, cos(player.current_angle))
