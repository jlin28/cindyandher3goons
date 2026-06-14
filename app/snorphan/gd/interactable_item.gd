extends StaticBody3D

@onready var interactable_area := $Area3D
@onready var interactable_notification := $Node3D

@onready var color_cont := get_node(^"colors").get_children()

var interactable_items_list = ["flowers", "special_powder", "apples"]
var label = ""

func _ready() -> void:
	interactable_notification.visible = false
	
	interactable_area.body_entered.connect(_on_entered)
	interactable_area.body_exited.connect(_on_exit)
	
	for item in interactable_items_list:
		if is_in_group(item):
			label = item
			break
			
	if label == 'flowers':
		var color_idx = randi_range(0, 3)
		color_cont[color_idx].visible = true
	
func _on_entered(body):
	if body.is_in_group('player'):
		interactable_notification.visible = true
		body.item_interactable = true
		
		body.current_interactable_item = self

func _on_exit(body):
	if body.is_in_group('player'):
		interactable_notification.visible = false
		body.item_interactable = false
		
		body.current_interactable_item = null
