extends StaticBody3D

@onready var interactable_area := $Area3D

@onready var medium := $medium_snowball
@onready var medium_collision := $medium_snowball_collision
@onready var small := $small_snowball
@onready var small_collision := $small_snowball_collision
@onready var branch1 := %branch
@onready var branch2 := %branch2

@export var can_build = true
@export var torso_in_place = false
@export var head_in_place = false

@export var pebble_cont = %pebbles.get_children()
@export var current_pebble = 0

func _ready() -> void:
	interactable_area.body_entered.connect(_on_entered)
	interactable_area.body_exited.connect(_on_exit)	
	
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
	if current_pebble < pebble_cont.Count:
		pebble_cont[current_pebble].visible = true
		pebble_cont[current_pebble] += 1
		return true
	else:
		return false
