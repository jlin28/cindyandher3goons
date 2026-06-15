extends Button

@onready var player := get_tree().get_first_node_in_group('player')
@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')

@onready var grandparent := get_parent().get_parent()
@onready var big_cont := grandparent.get_parent().get_parent().get_parent()
@onready var item := big_cont.get_node(^"Label")
@onready var label := grandparent.find_child('Label')
@onready var error_line := grandparent.find_child('Label2')
@onready var error_anim := error_line.get_child(0)
@onready var edit_line := grandparent.find_child('LineEdit')

func _pressed() -> void:
	if edit_line.text.is_valid_int():
		var value = int(edit_line.text)
		if value > player.current_items[item.text]:
			play_error()
		else:
			big_cont.visible = false
			label.text = ''
			error_line.visible = false
			edit_line.text = ''
			MultiplayerClient.remove_item(item.text, value)
	else:
		play_error()
		
func play_error():
	if not error_line.visible:
		error_line.visible = true
	else:
		if not error_anim.is_playing():
			error_anim.play("shake")
			
			await error_anim.animation_finished
			error_anim.stop()
