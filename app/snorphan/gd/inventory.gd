extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _unhandled_input(event: InputEvent) -> void:
	var inventory_index = -1
	# M3 Wheel Down --> inv goes from 1 to 6
	if(Input.is_action_pressed("right_click")):
		inventory_index += 1
		print("right button clik click")
	
	 #Code is wrong down there will fix when I get home
	 #M3 Wheel Up --> inv goes from 6 to 1
	#if(Input.is_action_pressed("mouse_up")):
		#
	 #Right clicks will deselect
	#if(Input.is_action_pressed("mouse_down")):
		##deselect code here
