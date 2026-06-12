extends CharacterBody3D

var speed = 14
var fall_acceleration = 75
var jump_velocity = 20
var time = 0.0; 

@export var current_angle: float

@onready var cam := %pivot

@onready var idle := %fox
@onready var anim_cont := %walk_cycle
@onready var anim_cont2 := %sprint_cycle
@onready var walk := %walk_cycle/AnimationPlayer
@onready var sprint := %sprint_cycle/AnimationPlayer
@onready var crouch := %foxcrouch
@onready var notification := %notification

@onready var idle_cape := %idle_cape
@onready var walk_cape := %walk_cape
@onready var sprint_cape := %sprint_cape
@onready var crouch_cape := %crouch_cape

@onready var normal_collision_shapes := get_tree().get_nodes_in_group("normal_collision")
@onready var crouch_collision_shapes := get_tree().get_nodes_in_group("crouch_collision")

@export var npc_interactable = false
@export var can_move = true
@export var current_interactable_npc = null

@export var item_interactable = false
@export var current_interactable_item = null
@export var current_held_item = null

@export var snowman_in_vicinity = null
@export var active_quests = []
@export var completion_status = []

@export var current_items = null
@export var full_inventory = false
@export var house_found = false

@export var snowman_items = ['snowball_S', 'snowball_M', 'snowball_L', 'stick', 'pebbles']

@export var equipped_cape = false

var prev_line = ""
var label_tick = -1

signal inventory_update
signal inventory_full

signal quest_update

func _ready() -> void:
	inventory_full.connect(_on_inventory_full)
	
func _physics_process(delta):
	var direction = Vector3.ZERO
	var rotation = Vector3.ZERO
	time += delta
	current_angle = cam.facing.y
	
	if can_move:
		if Input.is_action_pressed("move_right"):
			direction += Vector3(cos(current_angle), 0, -sin(current_angle))
			
		if Input.is_action_pressed("move_left"):
			direction -= Vector3(cos(current_angle), 0, -sin(current_angle))
			
		if Input.is_action_pressed("move_forward"):
			direction -= Vector3(sin(current_angle), 0, cos(current_angle))  # Forward is negative!
			
		if Input.is_action_pressed("move_back"):
			direction += Vector3(sin(current_angle), 0, cos(current_angle)) 
			
		if direction != Vector3.ZERO: 
			# look_at rotates your object so it faces a point (look_at(target_position, up_direction))
			# global_position is your character's position in the world
			# Vector3.UP gives you a point pointing upwards vs Vector3.Zero which has no direction
			look_at(global_position - direction, Vector3.UP)
			
			direction = direction.normalized()
		# Normalizing a vector maintains the original direction while changing the magnitute to 1.
		# This way diagonal movement isn't faster!

		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
	else:
		velocity.x = 0
		velocity.z = 0
		
	if not is_on_floor():
		velocity.y -= fall_acceleration * delta
	# delta = time since last physics frame, multiplying by this makes gravity independent of frame rate
		
	move_and_slide()
	
#@onready var idle_cape := %idle_cape
#@onready var walk_cape := %walk_cape
#@onready var sprint_cape := %sprint_cape
#@onready var crouch_cape := %crouch_cape

func _process(delta: float) -> void:
	if current_held_item and current_held_item in snowman_items:
		if 'snowball' in current_held_item and prev_line == '':
			notification.text = "Press [F] to build snowman"
		if label_tick > -1 and prev_line == '':
			notification.modulate = Color('#9f8974')
			label_tick = -1
	elif current_held_item and "cape" in current_held_item:
		notification.text = "Press [Q] to equip cape"
	else:
		if notification.text != '' and label_tick < 0: notification.text = ''
	
	if label_tick > -1:
		label_tick += 1
		if label_tick % 150 == 0:
			notification.text = prev_line
			notification.modulate = Color('#9f8974')
			label_tick = -1
			
	if Input.is_action_pressed("crouch"):
		if !normal_collision_shapes[0].disabled:
			for collision in normal_collision_shapes:
				collision.disabled = true
			for collision in crouch_collision_shapes:
				collision.disabled = false
			crouch.visible = true
			idle.visible = false
			anim_cont2.visible = false
			anim_cont.visible = false
			
			if equipped_cape:
				crouch_cape.visible = true
				if idle_cape.visible: idle_cape.visible = false
				if walk_cape.visible: walk_cape.visible = false
				if sprint_cape.visible: sprint_cape.visible = false
			
	elif can_move:
		if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back"):
			idle.visible = false
			
			if idle_cape.visible: idle_cape.visible = false
			if crouch_cape.visible: crouch_cape.visible = false
			
			if Input.is_action_pressed("sprint"):
				speed = 30
				anim_cont2.visible = true
				anim_cont.visible = false
				sprint.play("walk")
				
				if equipped_cape:
					sprint_cape.visible = true
					if walk_cape.visible: walk_cape.visible = false
			else:
				speed = 14
				anim_cont2.visible = false
				anim_cont.visible = true
				walk.play("walk")
				
				if equipped_cape:
					walk_cape.visible = true
					if sprint_cape.visible: sprint_cape.visible = false
		else: 
			idle.visible = true
			anim_cont2.visible = false
			anim_cont.visible = false
			walk.stop()
			sprint.stop()
			
			if equipped_cape:
				idle_cape.visible = true
				if crouch_cape.visible: crouch_cape.visible = false
				if walk_cape.visible: walk_cape.visible = false
				if sprint_cape.visible: sprint_cape.visible = false
			
	if Input.is_action_just_released("crouch"):
		if normal_collision_shapes[0].disabled:
			for collision in normal_collision_shapes:
				collision.disabled = false
			for collision in crouch_collision_shapes:
				collision.disabled = true
			crouch.visible = false
			idle.visible = true
		
	cam.position = position

func update_notification(new_line):
	if new_line != notification.text:
		prev_line = notification.text
		notification.text = new_line
		
		notification.modulate = Color(0.7,0,0)
		label_tick += 1

func _on_inventory_full():
	update_notification("Inventory is full!")
