extends MarginContainer

@onready var animation := $AnimationPlayer
@onready var img := find_child("img")
@onready var text := find_child("item")

@export var ticks = 0

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
				
func get_item_icon(item_name):
	if item_name == "snowball_S" or item_name == "snowball_M" or item_name == "snowball_L": #done
		return snowball_icon
	elif item_name == 'special_powder':
		return special_powder_icon
	elif item_name == 'apples':
		return apples_icon
	elif item_name == 'pebbles': 
		return pebbles_icon
	elif item_name == 'flowers':
		return flowers_icon
	elif item_name == 'slightly_worn_out_cape':
		return cape_icon
	elif item_name == 'stick': 
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
	
func play_alert(item):
	img.texture = get_item_icon(item)
	text.text = item.replace("_", " ")
	
	animation.play('slide_down')
	ticks = 1
	
func _process(delta: float) -> void:
	if ticks > 0:
		if ticks % 300 == 0:
			ticks = 0
			animation.pause()
			animation.play("fade_out")
			
			await get_tree().create_timer(0.7667).timeout
			reset()
		else:
			ticks += 1

func reset():
	animation.pause()
	animation.play("slide_down")
	animation.seek(0.0, true)
	animation.stop()
	
	animation.play("fade_out")
	animation.seek(0.0, true)
	animation.stop()
	
	img.texture = null
	text.text = ''
