extends Button

@onready var items_cont := %items_cont
@onready var item_info_cont := %item_info_cont

@onready var item_name := %item_name
@onready var img_cont := %img
@onready var item_status := %item_status
@onready var item_desc := %item_desc

func _pressed() -> void:
	items_cont.visible = true
	item_info_cont.visible = false
	
	item_name.text = ''
	item_status.text = ''
	item_desc.text = ''
	
	img_cont.get_node(^"NinePatchRect").modulate = Color("ffffff")
	
	var img = img_cont.get_node(^"NinePatchRect/Icon")
	img.texture = null
