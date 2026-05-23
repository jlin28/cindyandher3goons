extends MarginContainer

@onready var player := get_tree().get_first_node_in_group('player')
@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')
@onready var inventory := %inventory_slots
@onready var slots := inventory.get_children()

var snowball_icon = preload("res://static/items/snowball.png")

var inventory_index = -1
var inventory_requesting = false

func _process(delta: float) -> void:
	if player.inventory_update and not inventory_requesting:
		inventory_requesting = true
		MultiplayerClient.fetch_inventory()
		
func get_item_icon(item_name):
	if item_name == "snowball_S" or item_name == "snowball_M" or item_name == "snowball_L":
		return snowball_icon
	return null
		
func update_inventory(new_inv):
	print("INVENTORY RECEIVED: ", new_inv)

	for i in range(slots.size()):
		var background = slots[i].get_child(0)
		var image = background.get_node("Icon")
		var label = background.get_node("Count")
		var slot_data = new_inv.get(str(i), new_inv.get(i, {"item": "", "count": 0}))
		
		var item_name = slot_data.get("item", "")
		var count = int(slot_data.get("count", 0))
		var icon = get_item_icon(item_name)

		print("slot ", i, " item=", item_name, " count=", count, " icon=", icon)
		
		if item_name == "" or count <= 0:
			image.texture = null
			image.visible = false 
			label.text = ""
			label.visible = false
		else:
			#Why am I doing it like this..?
			image.anchor_left = 0
			image.anchor_top = 0
			image.anchor_right = 0
			image.anchor_bottom = 0
			image.offset_left = 3
			image.offset_top = 1
			image.offset_right = 23
			image.offset_bottom = 21
			image.size = Vector2(20, 20)
			image.scale = Vector2(1, 1)
			image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			image.visible = true
			image.texture = icon
			
			label.text = str(count)
			label.visible = true
			label.anchor_left = 0
			label.anchor_top = 0
			label.anchor_right = 1
			label.anchor_bottom = 1
			label.offset_left = 0
			label.offset_top = 12
			label.offset_right = -2
			label.offset_bottom = -1
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM

		player.inventory_update = false
		inventory_requesting = false
	
func _unhandled_input(event: InputEvent) -> void:
	# M3 Wheel Up --> inv goes from 1 to 6
	if(Input.is_action_pressed("mouse_up")):
		if inventory_index != -1:
			highlight(inventory_index, false)
		
		inventory_index += 1
		if inventory_index > 5:
			inventory_index = 0
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
		if inventory_index != -1:
			highlight(inventory_index, false)
					
		inventory_index = -1
		
func highlight(index: int, focus: bool):
	var current_slot = slots[index]
	var image = current_slot.get_child(0)
	
	if focus:
		image.modulate = Color(0.8,0.8,0.8,1)
	else:
		image.modulate = Color(1,1,1,1)
