extends Button

@onready var settings_cont := %settings
@onready var main_ui := %default

func _pressed() -> void:
	settings_cont.visible = true
	main_ui.visible = false
