extends Node2D

onready var Level = get_parent()
onready var Player = preload("res://Player/Player.tscn")


var active_players = []
var connected_devices = []

var ready = false

var next_player_id = 0

func _ready():
	yield(get_tree().create_timer(.5), "timeout")
	if Profile.global_preserve != {}:
		for x in Profile.global_preserve.keys():
			var dict = Profile.global_preserve[x]
			connected_devices.append(dict.device)
			Profile.global_preserve.erase(x)
			add_player(x, dict.device, dict.input_method, dict.color).change_skin(dict.skin)
			yield(get_tree().create_timer(.1), "timeout")
	
	ready = true
	


func _input(event):
	if Level.game_state == "Lobby" and Level.GUI.ui_focus == "none" and ready:
		if event.is_action("join"):
			if event is InputEventKey:
				if !connected_devices.has("Keyboard1") and event.scancode == KEY_W:
					connected_devices.append("Keyboard1")
					add_player(next_player_id, "Keyboard1", "Keyboard")
					
				if !connected_devices.has("Keyboard2") and event.scancode == KEY_UP:
					connected_devices.append("Keyboard2")
					add_player(next_player_id, "Keyboard2", "Keyboard")

			elif event is InputEventJoypadButton:
				if !connected_devices.has("Gamepad:" + str(event.device)):
					connected_devices.append("Gamepad:" + str(event.device))
					add_player(next_player_id, "Gamepad:" + str(event.device), "Gamepad")


func add_player(id, device, input_method, color = Color.white):
	next_player_id += 1
	active_players.append(id)
	var new_player = Player.instance()
	new_player.player_id = id
	new_player.device_type = device
	new_player.input_method = input_method
	new_player.color = color
	Profile.global_preserve[id] = {"device" : device, "input_method" : input_method, "skin" : 0, "color" : color}
	add_child(new_player)
	print(connected_devices)
	Level.GUI.player_join(new_player)
	return new_player

func _physics_process(delta):
	match Level.game_state:
		"Lobby":
			for x in get_children():
				if x.ready and !Level.ready_players.has(x.player_id):
					Level.ready_players.append(x.player_id)
				if !x.ready and Level.ready_players.has(x.player_id):
					Level.ready_players.erase(x.player_id)


