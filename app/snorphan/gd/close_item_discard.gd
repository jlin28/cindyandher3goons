extends Button

@onready var grandparent := get_parent().get_parent()
@onready var big_cont := grandparent.get_parent().get_parent().get_parent()
@onready var label := grandparent.find_child('Label')
@onready var error_line := grandparent.find_child('Label2')
@onready var edit_line := grandparent.find_child('LineEdit')

func _pressed() -> void:
	big_cont.visible = false
	label.text = ''
	error_line.visible = false
	edit_line.text = ''
