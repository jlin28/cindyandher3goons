extends Button

@onready var player := get_tree().get_first_node_in_group('player')
@onready var name_label := %name 
@onready var dialogue_box := %dialogue
@onready var next_button := %next

func _pressed() -> void:
	get_node(^"..").visible = false
	next_button.visible = true
	
	dialogue_box.text = text
	name_label.text = "< %s >" %player.get_node_or_null('username').text
