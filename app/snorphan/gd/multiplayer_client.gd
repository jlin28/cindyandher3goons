extends Node

@export var remote_player_scene: PackedScene
@export var local_player: Node3D

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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

func handle_msg(data):
	var msg_type = data.get("type", "")

	if msg_type == "assign_id":
		my_id = str(data.get("id", ""))

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

func send_position():
	var pos = local_player.global_position
	var rot_y = local_player.global_rotation.y
	
	var moved = pos.distance_to(last_sent_pos) > 0.01
	var rotated = abs(rot_y - last_sent_rot_y) > 0.01
	
	if not moved and not rotated:
		return

	last_sent_pos = pos
	last_sent_rot_y = rot_y
	
	var data = {
		"type": "position",
		"x": pos.x,
		"y": pos.y,
		"z": pos.z,
		"ry": local_player.global_rotation.y
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

func spawn_remote_player(player_id):
	var remote_copy = remote_player_scene.instantiate()
	remote_players[player_id] = remote_copy

	# I have no idea what this means but I couldn't get it to spawn and searched it up and now my brain is too fried!
	get_tree().current_scene.call_deferred("add_child", remote_copy)

func remove_remote_player(player_id):
	if remote_players.has(player_id):
		var remote_player = remote_players[player_id]
		remote_player.queue_free()
		remote_players.erase(player_id)
		print("Removed remote player ", player_id)
