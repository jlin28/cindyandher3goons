extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _unhandled_input(event: InputEvent) -> void:
	var inventory_index = -1
	# M3 Wheel Down --> inv goes from 1 to 6
	if(event == InputEventMouseButton and event.pressed and Input.get_mouse_button_mask() == MOUSE_BUTTON_MASK_RIGHT):
		inventory_index += 1
		print("right button clik click")
	
	# Code is wrong down there will fix when I get home
	# M3 Wheel Up --> inv goes from 6 to 1
	#if(event == InputEventMouseButton and event.pressed and MouseButton.get_button_index() == MOUSE_BUTTON_WHEEL_UP):
	#	
	# Right clicks will deselect
	#if(event == InputEventMouseButton and event.pressed and MouseButton.get_button_index() == MOUSE_BUTTON_RIGHT):
	#	#deselect code here
