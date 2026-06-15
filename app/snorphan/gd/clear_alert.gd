extends Button

@onready var alert_cont := get_tree().get_first_node_in_group("alert")

func _pressed() -> void:
	alert_cont.reset()
