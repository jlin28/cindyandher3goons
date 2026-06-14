extends MarginContainer

@onready var player := get_tree().get_first_node_in_group('player')
@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')

@onready var items := %items_cont.get_node(^"ScrollContainer/items")
@onready var row0 := items.get_node(^"row1").get_children()
@onready var row1 := items.get_node(^"row2").get_children()
@onready var row2 := items.get_node(^"row3").get_children()
@onready var row3 := items.get_node(^"row4").get_children()
@onready var rows = [row0,row1,row2,row3]

@onready var item_name := %item_name
@onready var img_cont := %img
@onready var item_status := %item_status
@onready var item_desc := %item_desc

signal initialize_encyclopedia

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

func _ready() -> void:
	initialize_encyclopedia.connect(_set_up_items)
	
func _set_up_items():
	for item in player.unlocked_items:
		for row in rows:
			if item in row.map(func(n): return n.name):
				var item_img_cont = items.find_child(item, true, false)
				var cont = item_img_cont.get_node(^"NinePatchRect")
				cont.modulate = Color("ffffff")
				break
				
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

func update_item_status(item):
	var item_img_cont = items.find_child(item, true, false)
	var cont = item_img_cont.get_node(^"NinePatchRect")
	cont.modulate = Color("ffffff")
	
func fetch_item_info(item):
	MultiplayerClient.fetch_item_info(item)

func load_item_info(item, desc):
	item_name.text = item
	item_desc.text = desc
	
	if item in player.unlocked_items:
		item_status.text = 'UNLOCKED'
		img_cont.get_node(^"NinePatchRect").modulate = Color("ffffff")
	else:
		item_status.text = 'NOT DISCOVERED'
		img_cont.get_node(^"NinePatchRect").modulate = Color("858585")
	
	var img = img_cont.get_node(^"NinePatchRect/Icon")
	img.texture = get_item_icon(item)
