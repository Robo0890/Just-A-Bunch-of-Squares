extends Node2D

onready var Level = get_parent()
onready var Player = preload("res://Player/Player.tscn")


var active_players = []
var connected_devices = []

func _input(event):
	if Level.game_state == "Lobby":
		if event.is_action("join"):
			if event is InputEventKey:
				if !connected_devices.has("keyboard1") and event.scancode == KEY_W:
					connected_devices.append("keyboard1")
					add_player(active_players.size(), "Keyboard1")
					
				if !connected_devices.has("keyboard2") and event.scancode == KEY_UP:
					connected_devices.append("keyboard2")
					add_player(active_players.size(), "Keyboard2")
					
			elif event is InputEventJoypadButton:
				if !connected_devices.has("Gamepad:" + str(event.device)):
					connected_devices.append("Gamepad:" + str(event.device))
					add_player(active_players.size(), "Gamepad:" + str(event.device))
			

func add_player(id, device):
	active_players.append(id)
	var new_player = Player.instance()
	new_player.player_id = id
	new_player.device_type = device
	add_child(new_player)
	print("Added Player " + str(id) + " from device: " + str(device))
	Level.GUI.player_join(new_player)

func _physics_process(delta):
	match Level.game_state:
		"Lobby":
			for x in get_children():
				if x.ready and !Level.ready_players.has(x.player_id):
					Level.ready_players.append(x.player_id)
				if !x.ready and Level.ready_players.has(x.player_id):
					Level.ready_players.erase(x.player_id)
