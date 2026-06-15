extends CharacterBody3D

@onready var idle := %fox
@onready var anim_cont := %walk_cycle
@onready var anim_cont2 := %sprint_cycle
@onready var walk := %walk_cycle/AnimationPlayer
@onready var sprint := %sprint_cycle/AnimationPlayer

@onready var idle_cape := %idle_cape
@onready var walk_cape := %walk_cape
@onready var sprint_cape := %sprint_cape
@onready var crouch_cape := %crouch_cape

@onready var crouch := %foxcrouch

@onready var normal_collision_shapes := get_tree().get_nodes_in_group("normal_collision")
@onready var crouch_collision_shapes := get_tree().get_nodes_in_group("crouch_collision")

@onready var chat_text := %chat_text
@onready var chat_cont := %chat_cont

var msg_tick = -1

func _process(delta: float) -> void:
	if msg_tick > -1:
		msg_tick += 1
		if msg_tick % 1500 == 0:
			close_message()

func update_current_action(action, cape):
	if action == "crouch":
		if !normal_collision_shapes[0].disabled:
			for collision in normal_collision_shapes:
				collision.disabled = true
			for collision in crouch_collision_shapes:
				collision.disabled = false
			crouch.visible = true
			idle.visible = false
			anim_cont2.visible = false
			anim_cont.visible = false
			
			if cape:
				crouch_cape.visible = true
				if idle_cape.visible: idle_cape.visible = false
				if walk_cape.visible: walk_cape.visible = false
				if sprint_cape.visible: sprint_cape.visible = false
			
	elif action == "sprint":
		idle.visible = false
		crouch.visible = false
			
		if idle_cape.visible: idle_cape.visible = false
		if crouch_cape.visible: crouch_cape.visible = false
			
		anim_cont2.visible = true
		anim_cont.visible = false
		sprint.play("walk")
		
		if cape:
			sprint_cape.visible = true
			if walk_cape.visible: walk_cape.visible = false

	elif action == "walk":
		anim_cont2.visible = false
		anim_cont.visible = true
		walk.play("walk")
		
		if cape:
			walk_cape.visible = true
			if sprint_cape.visible: sprint_cape.visible = false

	else: 
		if normal_collision_shapes[0].disabled:
			for collision in normal_collision_shapes:
				collision.disabled = false
			for collision in crouch_collision_shapes:
				collision.disabled = true
				
		idle.visible = true
		crouch.visible = false
		anim_cont2.visible = false
		anim_cont.visible = false
		walk.stop()
		sprint.stop()
			
		if cape:
			idle_cape.visible = true
			if crouch_cape.visible: crouch_cape.visible = false
			if walk_cape.visible: walk_cape.visible = false
			if sprint_cape.visible: sprint_cape.visible = false
			
func update_chat(msg):
	chat_text.text = msg
	chat_cont.visible = true
	
	msg_tick = 0

func close_message():
	var anim_cont = chat_cont.get_child(0)
	anim_cont.play("fade_out")
	
	await anim_cont.animation_finished
	chat_text.text = ''
	chat_cont.visible = false
	anim_cont.stop()
	
	msg_tick = -1
