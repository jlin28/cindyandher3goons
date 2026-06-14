extends Button

@onready var en_cont := get_tree().get_first_node_in_group('encyclopedia')
@onready var items_cont := %items_cont
@onready var item_info_cont := %item_info_cont

@onready var item = get_parent().name

func _pressed() -> void:
	items_cont.visible = false
	item_info_cont.visible = true
	
	en_cont.fetch_item_info(item)
