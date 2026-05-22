extends MarginContainer

@onready var player := get_tree().get_first_node_in_group('player')
@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')
@onready var inventory := %inventory_slots
@onready var slots := inventory.get_children()

var inventory_index = -1

func _process(delta: float) -> void:
	if player.inventory_update:
		MultiplayerClient.fetch_inventory(player.get_child(0).text)
		
func update_inventory(new_inv):
	for item in new_inv:
		var i = new_inv.index(item)
		
		var text = slots[i].get_child(1)
		text.text = item.item
	
	player.inventory_update = false
		
func _unhandled_input(event: InputEvent) -> void:
	# M3 Wheel Up --> inv goes from 1 to 6
	if(Input.is_action_pressed("mouse_up")):
		if inventory_index != -1:
			highlight(inventory_index, false)
		
		inventory_index += 1
		if inventory_index > 5:
			inventory_index = 1
		highlight(inventory_index, true)
			
		
	 #M3 Wheel Down --> inv goes from 6 to 1
	if(Input.is_action_pressed("mouse_down")):
		if inventory_index != -1:
			highlight(inventory_index, false)
		
		inventory_index -= 1
		if inventory_index < 0:
			inventory_index = 5
		highlight(inventory_index, true)

		
	#Right clicks will deselect
	if(Input.is_action_pressed("right_click")):
		highlight(inventory_index, false)
		
		inventory_index = -1
		
func highlight(index: int, focus: bool):
	var current_slot = slots[inventory_index]
	var image = current_slot.get_child(0)
	
	if focus:
		image.modulate = Color(0.8,0.8,0.8,1)
	else:
		image.modulate = Color(1,1,1,1)
