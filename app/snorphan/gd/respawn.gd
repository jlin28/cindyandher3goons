extends Button

@onready var respawn_prompt := %respawn_prompt_cont

func _pressed() -> void:
	respawn_prompt.visible = true
	
