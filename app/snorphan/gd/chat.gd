extends LineEdit

@onready var player := get_tree().get_first_node_in_group('player')

func _ready() -> void:
	text_submitted.connect(_on_text_submitted)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("chat"): 
		grab_focus()
		player.can_move = false
	
	if Input.is_action_just_pressed("right_click"):
		if has_focus():
			release_focus()
			player.can_move = true
			text = ''

func _on_text_submitted(submitted_text: String) -> void:
	if has_focus():
		release_focus()
		player.can_move = true
				
		player.update_chat(text)
		text = ''
