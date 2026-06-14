extends StaticBody3D

@onready var interactable_area := $Area3D

@onready var medium := $medium_snowball
@onready var medium_collision := $medium_snowball_collision
@onready var small := $small_snowball
@onready var small_collision := $small_snowball_collision

@onready var branch1 := %branch1
@onready var branch2 := %branch2

@onready var pebble_cont = get_node(^"pebbles").get_children()
@onready var button_cont = get_node(^"buttons").get_children()

@onready var hat := %hat
@onready var carrot := %carrot
@onready var scarf := %scarf

@onready var id := %id

@export var can_build = true
@export var torso_in_place = false
@export var head_in_place = false

@export var current_pebble = 0
@export var current_button = 0

@export var snowman_items = ['snowball_S', 'snowball_M', 'snowball_L', 'stick', 'pebbles']

func _ready() -> void:
	var id_num = 0
	
	interactable_area.body_entered.connect(_on_entered)
	interactable_area.body_exited.connect(_on_exit)	
	
	for i in range(1,15):
		id_num += randi_range(0,9) * pow(10,i)
	
	id.text = id_num
	
func _on_entered(body):
	if body.is_in_group('player'):
		body.snowman_in_vicinity = self

func _on_exit(body):
	if body.is_in_group('player'):
		body.snowman_in_vicinity = null

func build(snowball):
	if medium.visible and 'S' in snowball:
		small.visible = true
		small_collision.disabled = false
		can_build = false
		head_in_place = true
		return true
	elif !medium.visible and 'M' in snowball:
		medium.visible = true
		medium_collision.disabled = false
		torso_in_place = true
		return true
	else:
		return false

func arms():
	if branch2.visible:
		return false
	elif branch1.visible:
		branch2.visible = true
		return true
	else:
		branch1.visible = true
		return true
	
func pebble():
	if current_pebble < pebble_cont.size():
		pebble_cont[current_pebble].visible = true
		current_pebble += 1
		return true
	else:
		return false

func accessories(item):
	if item == "hat" and not hat.visible:
		hat.visible = true
		return true
	elif item == "carrot" and not carrot.visible:
		carrot.visible = true
		return true
	elif "scarf" in item and not scarf.visible:
		scarf.visible = true
		return true
	elif item == "button" and current_button < button_cont.size():
		button_cont[current_button].visible = true
		current_button += 1
		return true
	else:
		return false
