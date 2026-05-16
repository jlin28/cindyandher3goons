extends Button

@onready var closed_cont := %closed_quests_cont

func _pressed() -> void:
	closed_cont.visible = true
	get_node(^"../../../../..").visible = false
