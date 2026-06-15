extends Node

@onready var dialogue_cont := get_tree().get_first_node_in_group('dialogue')
@onready var quests_cont := get_tree().get_first_node_in_group('quests')
@onready var inventory_cont := get_tree().get_first_node_in_group('inv')
@onready var player := get_tree().get_first_node_in_group('player')
@onready var encyclopedia := get_tree().get_first_node_in_group('encyclopedia')
@onready var main_node := get_tree().get_first_node_in_group('main_node')
@onready var alert_cont := get_tree().get_first_node_in_group("alert")

@export var remote_player_scene: PackedScene
@export var local_player: Node3D
@export var username := "guest"

#var server_url := "ws://127.0.0.1:3030/ws/game"
var server_url := "wss://cindyandher3goons.me/ws/game"

var socket := WebSocketPeer.new()
var connected := false

var my_id := ""
var remote_players := {}

var send_timer = 0.0
const send_interval = 0.05
var last_sent_pos = Vector3.ZERO
var last_sent_rot_y = 0.0
var last_sent_action = null
var last_sent_cape = null

var font = preload("res://static/PeaberryDoublespace.ttf")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_username()
	set_local_username()
	
	var error = socket.connect_to_url(server_url)
	if error != OK:
		print("Could not connect to WebSocket server")
	else:
		print("Trying to connect to WebSocket server...")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	socket.poll() # Godot requires this for the socket to update

	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if not connected:
			connected = true
			print("Connected!")

		while socket.get_available_packet_count() > 0: # other waiting messages
			var packet = socket.get_packet().get_string_from_utf8() # converts packet bytes for the one read packet to readable text
			print("From server: ", packet)

			var data = JSON.parse_string(packet) # convert json from node into godot dict
			
			# ignore non-JSON msgs
			if typeof(data) != TYPE_DICTIONARY:
				continue

			handle_msg(data)

		if my_id != "":
			send_timer += delta
			if send_timer >= send_interval:
				send_timer = 0.0
				send_position()
			
	elif state == WebSocketPeer.STATE_CLOSED:
		if connected:
			print("Disconnected!")
			connected = false

func load_username() -> void:
	if OS.has_feature("web"):
		var page_username = JavaScriptBridge.eval("window.parent.USERNAME", true)
		if page_username != null:
			username = str(page_username)

# does this even belong here..!
func set_local_username() -> void:
	if local_player == null:
		return
	var label = local_player.get_node_or_null("username")
	if label != null:
		label.text = username

func set_remote_username(player_id: String, username_text: String) -> void:
	if not remote_players.has(player_id):
		return
		
	var remote_player = remote_players[player_id]
	var label = remote_player.get_node_or_null("username")
	if label != null:
		label.text = username_text


func handle_msg(data):
	var msg_type = data.get("type", "")

	if msg_type == "assign_id":
		my_id = str(data.get("id", ""))
		send_username()
		inventory_cont._on_inventory_update()
		quests_cont.fetch_quests()
		fetch_cape_info()
		fetch_initial_enc()
		instantiate_snowmen()
		
	elif msg_type == "player_name":
		var player_id = str(data.get("id", ""))
		var username_text = str(data.get("username", ""))
		set_remote_username(player_id, username_text)

	elif msg_type == "world_state":
		for player_data in data.get("players", []):
			update_remote_player(player_data)

	elif msg_type == "player_state":
		update_remote_player(data)

	elif msg_type == "player_joined":
		update_remote_player(data)

	elif msg_type == "player_left":
		var player_id = str(data.get("id", ""))
		remove_remote_player(player_id)
	
	elif msg_type == "dialogue":
		dialogue_cont.quest_status = data.get('quest_status')
		send_dialogue(data)
	
	elif msg_type == "add_item":
		if data.get("success"):
			player.inventory_update.emit()
		else:
			player.inventory_full.emit()
			
	elif msg_type == "remove_item":
		player.inventory_update.emit()
		
	elif msg_type == "fetch_inventory":
		send_inventory(data)
		
	elif msg_type == "fetch_quests":
		quests_cont.update_quests(data.quests)
		
	elif msg_type == "add_quest" or msg_type == "remove_quest":
		quests_cont.change_quests.emit()
	
	elif msg_type == "cape_info":
		if data.get("cape_status")[0] == 0:
			player.equipped_cape = false
		else:
			player.equipped_cape = true
		
		print(data.get("cape"))
		print(player.equipped_cape)
	
	elif msg_type == "init_encyclopedia":
		player.unlocked_items = data.get("items", [])
		encyclopedia.initialize_encyclopedia.emit()
				
	elif msg_type == "item_info":
		encyclopedia.load_item_info(data.get("item"), data.get("desc"))
	
	elif msg_type == "instantiate_snowmen":
		main_node.instantiate_snowmen(data.get("snowmen", {}))
		
func send_username():
	var data = {
		"type": "set_username",
		"username": username
	}
	socket.send_text(JSON.stringify(data))
	
func send_position():
	var pos = local_player.global_position
	var rot_y = local_player.global_rotation.y
	var curr_action = player.current_action
	var cape_status = player.equipped_cape
	var moved = pos.distance_to(last_sent_pos) > 0.01
	var rotated = abs(rot_y - last_sent_rot_y) > 0.01
	
	var changed_action = last_sent_action != curr_action
	var changed_cape_status = last_sent_cape != cape_status
	
	if not moved and not rotated and not changed_action and not changed_cape_status:
		return

	last_sent_pos = pos
	last_sent_rot_y = rot_y
	last_sent_action = curr_action
	last_sent_cape = cape_status
	
	var data = {
		"type": "position",
		"x": pos.x,
		"y": pos.y,
		"z": pos.z,
		"ry": rot_y,
		"action": curr_action,
		"cape": cape_status
	}
	socket.send_text(JSON.stringify(data))

func update_remote_player(data):
	var player_id = str(data.get("id", ""))
	if player_id == my_id:
		return
	if player_id == "":
		return
	if not remote_players.has(player_id):
		spawn_remote_player(player_id)

	var remote_player = remote_players[player_id]
	remote_player.global_position = Vector3(
		float(data.get("x", 0)),
		float(data.get("y", 0)),
		float(data.get("z", 0))
	)
	remote_player.global_rotation.y = float(data.get("ry", 0))
	
	remote_player.update_current_action(data.get("action", "idle"), data.get("cape", false))
	
	var username_text = str(data.get("username", ""))
	if username_text != "":
		set_remote_username(player_id, username_text)

func spawn_remote_player(player_id):
	var remote_copy = remote_player_scene.instantiate()
	remote_players[player_id] = remote_copy

	# I have no idea what this means but I couldn't get it to spawn and searched it up and now my brain is too fried!
	get_tree().current_scene.add_child(remote_copy)

func remove_remote_player(player_id):
	if remote_players.has(player_id):
		remote_players[player_id].queue_free()
		remote_players.erase(player_id)
		print("Removed remote player ", player_id)
		
func retrieve_dialogue(npc):
	var data = {
		"type": "dialogue",
		"npc": npc,
	}
	
	socket.send_text(JSON.stringify(data))
	
func send_dialogue(data):
	dialogue_cont.receive_dialogue(data.dialogue)
	print(data)
	
func logout():
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.parent.location.href = '/exit'", true)

func add_item(item, quantity):
	var data = {
		"type": "add_item",
		"item": item,
		"quantity": quantity,
		"add": true
	}
	
	socket.send_text(JSON.stringify(data))
	
	if item not in player.unlocked_items:
		add_to_enc(item)
		player.unlocked_items.append(item)
		encyclopedia.update_item_status(item)
		alert_cont.play_alert(item)
		
	
func remove_item(item, quantity):
	var data = {
		"type": "remove_item",
		"item": item,
		"quantity": quantity,
		"add": false
	}
	
	socket.send_text(JSON.stringify(data))
	
func fetch_inventory():
	var data = {
		"type": "fetch_inventory",
	}
	
	socket.send_text(JSON.stringify(data))
	
func send_inventory(inv):
	inventory_cont.update_inventory(inv.inv)
	
func add_quest(npc):
	var data = {
		"type": "add_quest",
		"npc": npc
	}
	
	socket.send_text(JSON.stringify(data))
	
func remove_quest(npc):
	var data = {
		"type": "remove_quest",
		"npc": npc
	}
	
	socket.send_text(JSON.stringify(data))

func fetch_quests():
	var data = {
		"type": "fetch_quests",
	}
	
	socket.send_text(JSON.stringify(data))
	
func complete_quest(npc):
	var data = {
		"type": "complete_quest",
		"npc": npc
	}
	
	socket.send_text(JSON.stringify(data))
		
func fetch_cape_info():
	var data = {
		"type": "cape_info"
	}
	
	socket.send_text(JSON.stringify(data))

func fetch_initial_enc():
	var data = {
		"type": "init_encyclopedia"
	}
	
	socket.send_text(JSON.stringify(data))
	
func fetch_item_info(item):
	var data = {
		"type": "item_info",
		"item": item
	}
	
	socket.send_text(JSON.stringify(data))

func add_to_enc(item):
	var data = {
		"type": "add_to_enc",
		"item": item
	}
	
	socket.send_text(JSON.stringify(data))
	
func update_cape_status():
	var data = {
		"type": "update_cape"
	}
	
	socket.send_text(JSON.stringify(data))

func create_snowman(position, y_rotation, id):
	var data = {
		"type": "create_snowman",
		"x_coord": position.x,
		"y_coord": position.y,
		"z_coord": position.z,
		"y_rot": y_rotation,
		"id": id
	}
	
	socket.send_text(JSON.stringify(data))

func update_snowman(item, id):
	var data = {
		"type": "update_snowman",
		"item": item,
		"id": id
	}
	
	socket.send_text(JSON.stringify(data))
	
func instantiate_snowmen():
	var data = {
		"type": "instantiate_snowmen"
	}
	
	socket.send_text(JSON.stringify(data))
