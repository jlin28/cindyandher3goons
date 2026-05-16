extends Button

@onready var open_cont := %open_quests_cont

func _pressed() -> void:
	open_cont.visible = true
	get_node(^"../../../..").visible = false
