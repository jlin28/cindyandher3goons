extends MarginContainer

@onready var player := get_tree().get_first_node_in_group('player')
@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')
@onready var inventory := %inventory_slots
@onready var slots := inventory.get_children()
@onready var labels := %item_labels.get_children()

var snowball_icon = preload("res://static/items/snowball.png")
var apples_icon = preload("res://static/items/apples.png")
var apple_pie_icon = preload("res://static/items/apple_pie_recipe.png")
var button_icon = preload("res://static/items/button.png")
var flowers_icon = preload("res://static/items/flowers.png")
var hat_icon = preload("res://static/items/hat.png")
var ice_sculpture_icon = preload("res://static/items/ice_sculpture.png")
var old_plushie_icon = preload("res://static/items/old_plushie.png")
var pebbles_icon = preload("res://static/items/pebbles.png")
var scarf_icon = preload("res://static/items/red_scarf.png")
var cape_icon = preload("res://static/items/slightly_worn_out_cape.png")
var special_powder_icon = preload("res://static/items/special_powder.png")
var stick_icon = preload("res://static/items/stick.png")
var carrot_icon = preload("res://static/items/carrot.png")

var inventory_index = -1
	
func _ready() -> void:
	player.inventory_update.connect(_on_inventory_update)

func _on_inventory_update() -> void:
	if player.current_interactable_item: player.current_interactable_item.queue_free()
	player.item_interactable = false
	
	MultiplayerClient.fetch_inventory()

func get_item_icon(item_name):
	if item_name == "snowball_S" or item_name == "snowball_M" or item_name == "snowball_L": #done
		return snowball_icon
	elif item_name == 'special_powder':
		return special_powder_icon
	elif item_name == 'apples':
		return apples_icon
	elif item_name == 'pebbles': #done
		return pebbles_icon
	elif item_name == 'flowers':
		return flowers_icon
	elif item_name == 'slightly_worn_out_cape':
		return cape_icon
	elif item_name == 'stick': #done
		return stick_icon
	elif item_name == 'old_plushie':
		return old_plushie_icon
	elif item_name == 'ice_sculpture':
		return ice_sculpture_icon
	elif item_name == 'apple_pie_recipe':
		return apple_pie_icon
	elif item_name == 'red_scarf':
		return scarf_icon
	elif item_name == 'hat':
		return hat_icon
	elif item_name == 'carrot':
		return carrot_icon
	elif item_name == 'button':
		return button_icon
		
	return null
		
func update_inventory(new_inv):
	print("INVENTORY RECEIVED: ", new_inv)
	player.full_inventory = true
	
	var current_items = {}
	for key in new_inv:
		var item = new_inv.get(key).get('item')
		var count = new_inv.get(key).get('count')
		
		if item not in current_items:
			current_items[item] = count
		
			
	player.current_items = current_items
	for i in range(slots.size()):
		var background = slots[i].get_child(0)
		var image = background.get_node("Icon")
		var label = background.get_node("Count")
		var slot_data = new_inv.get(str(i), new_inv.get(i, {"item": "", "count": 0}))
		
		var item_name = slot_data.get("item", "")
		var count = int(slot_data.get("count", 0))
		var icon = get_item_icon(item_name)
		
		if '_' in item_name:
			item_name = item_name.replace('_', ' ')
		labels[i].get_child(0).text = item_name
			

		print("slot ", i, " item=", item_name, " count=", count, " icon=", icon)
		
		if item_name == "" or count <= 0:
			player.full_inventory = false
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
		
	var quests_cont = get_tree().get_first_node_in_group('quests')
	if quests_cont and quests_cont.current_quests:
		quests_cont.update_quests_progress()
	
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
	
	# Pressing keys 1-6 will select 1-6, pressing again will deselect
	if(Input.is_action_pressed("key_1")):
		key_press(1)
	if(Input.is_action_pressed("key_2")):
		key_press(2)
	if(Input.is_action_pressed("key_3")):
		key_press(3)
	if(Input.is_action_pressed("key_4")):
		key_press(4)
	if(Input.is_action_pressed("key_5")):
		key_press(5)
	if(Input.is_action_pressed("key_6")):
		key_press(6)
		
func highlight(index: int, focus: bool):
	var current_slot = slots[index]
	var current_label = labels[index].get_child(0)

	var image = current_slot.get_child(0)
	if focus:
		image.modulate = Color(0.8,0.8,0.8,1)
		if current_label.text != "":
			current_label.visible = true
			if ' ' in current_label.text:
				player.current_held_item = current_label.text.replace(' ', '_')
			else:
				player.current_held_item = current_label.text
		#else:
			
	else:
		image.modulate = Color(1,1,1,1)
		current_label.visible = false
		player.current_held_item = null

func key_press(key: int):
	if inventory_index == key - 1:
		highlight(inventory_index, false)
		inventory_index = -1
	else:
		highlight(inventory_index, false)
		inventory_index = key - 1
		highlight(inventory_index, true)
