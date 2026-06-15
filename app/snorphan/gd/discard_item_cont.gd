extends MarginContainer

@onready var player := get_tree().get_first_node_in_group('player')
@onready var label := get_node(^"MarginContainer/MarginContainer/VBoxContainer/Label")
@onready var item := get_node(^"Label")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("discard_item") and player.current_held_item:
		label.text = "HOW MANY %s WOULD YOU LIKE TO DISCARD?" %player.current_held_item.replace("_", ' ')
		item.text = player.current_held_item
		visible = true
