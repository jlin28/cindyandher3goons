extends MarginContainer

@onready var inventory := %inventory_slots
@onready var slots := inventory.get_children()

var inventory_index = -1

func _unhandled_input(event: InputEvent) -> void:
	# M3 Wheel Up --> inv goes from 1 to 6
	if(Input.is_action_pressed("mouse_up")):
		if inventory_index != -1:
			var current_slot = slots[inventory_index]
			var image = current_slot.get_child(0)
			image.modulate = Color(1,1,1,1)
		
		inventory_index += 1
		if inventory_index > 5:
			inventory_index = 1
		var current_slot = slots[inventory_index]
		var image = current_slot.get_child(0)
		image.modulate = Color(0.8,0.8,0.8,1)
			
		
	 #M3 Wheel Down --> inv goes from 6 to 1
	if(Input.is_action_pressed("mouse_down")):
		if inventory_index != -1:
			var current_slot = slots[inventory_index]
			var image = current_slot.get_child(0)
			image.modulate = Color(1,1,1,1)
		
		inventory_index -= 1
		if inventory_index < 0:
			inventory_index = 5
		var current_slot = slots[inventory_index]
		var image = current_slot.get_child(0)
		image.modulate = Color(0.8,0.8,0.8,1)

		
	#Right clicks will deselect
	if(Input.is_action_pressed("right_click")):
		var current_slot = slots[inventory_index]
		var image = current_slot.get_child(0)
		image.modulate = Color(1,1,1,1)
		
		inventory_index = -1
