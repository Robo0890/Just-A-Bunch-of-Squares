extends Node


var ready_players = []
var game_state = "Lobby"
var gamemode = "Classic"

var is_resetting = false

var leaderboard_data = {}

var player_count : int

onready var Game_Object = get_tree().get_nodes_in_group("Game")[0]
onready var Game_Camera = $Camera
onready var GUI = $Control/GUI
onready var Manager = $Manager

onready var Cloud = $CloudGame

onready var Game : Object
onready var Classic = preload("res://Gamemodes/Classic/Game.tscn")
#onready var Floor_Is_Lava = preload("res://Gamemodes/Floor Is Lava/Game.tscn")
#onready var Space_Jump = preload("res://Gamemodes/Space Jump/Game.tscn")

func _ready():
	$IPGetter.request("https://ipv4.icanhazip.com/", [], false, HTTPClient.METHOD_GET)
	
	UIAudio.play_sound("maximize_006")
	
	change_gamemode(Profile.data.gamemode)
	
	var joincode = JavaScript.eval("""
		var url_string = window.location.href;
		var url = new URL(url_string);
		url.searchParams.get("join");""")
		
	if joincode != null:
		Firebase.Firestore.collection("CloudGames").get(str(joincode))
		
	if Profile.gift_link != "":
		GUI._on_Shop_pressed()

func _physics_process(delta):
	match game_state:
		"Lobby":
			for player in $Manager.get_children():
				if player.position.y >= 1200:
					player.kill(true, true)
			match GUI.ui_focus:
				"Shop":
					$Camera.position = lerp($Camera.position, Vector2(1024,0), .1)
				"Options":
					$Camera.position = lerp($Camera.position, Vector2(1024,300), .1)
				"none":
					$Camera.position = lerp($Camera.position, Vector2(512,300), .1)
				"Manage":
					$Camera.position = lerp($Camera.position, Vector2(512,450), .1)

			$Camera.zoom = lerp($Camera.zoom, Vector2(1,1), .1)
			if ready_players.size() == $Manager.get_child_count() and $Manager.get_child_count() != 0:
				game_start()
				
		"Playing":
			$Camera.zoom = lerp($Camera.zoom, Vector2(2,2), .1)
			
		"End":
			$Camera.zoom = lerp($Camera.zoom, Vector2(1,1), .1)
			$Camera.position = lerp($Camera.position, Vector2(512,300), .1)
			if !is_resetting and ready_players.size() == $Manager.get_child_count() and $Manager.get_child_count() != 0:
				reset()

func game_start():
	UIAudio.play_sound("Custom/slam_001")
	if !Game.is_singleplayer and $Manager.get_children().size() <= 1:
		OS.alert("This is a multiplayer gamemode")
		ready_players.clear()
		for player in $Manager.get_children():
			player.ready = false
		return
		
	player_count = $Manager.get_child_count()
	Game_Object = get_tree().get_nodes_in_group("Game")[0]
	game_state = "Playing"
	Game_Object.players_left = player_count
	Game_Object.start()
	for x in $Manager.get_children():
		x.active = true
	
func end_game(leaderboard : Dictionary):
	Profile.data.stats.games += 1
	ready_players = []
	leaderboard_data = leaderboard
	for x in $Manager.get_children():
		x.active = false
		x.frozen = true
	game_state = "End"

func change_gamemode(new_gamemode : String):
	Profile.data.gamemode = new_gamemode
	Game = load("res://Gamemodes/" + new_gamemode + "/Game.tscn").instance()
	get_tree().get_nodes_in_group("Game")[0].queue_free()
	gamemode = new_gamemode
	new_gamemode = new_gamemode.replace(" ", "_")
	add_child(Game)
	Save.save_data(Profile.data, "jabos_profile")

func reset():
	for card in $Control/GUI/Leaderboard/Cards.get_children():
		card.set_script(null)
	Save.save_data(Profile.data, "jabos_profile")
	is_resetting = true
	$Reset_Timer.start(1)

func _on_Reset_Timer_timeout():
	for Player in $Manager.get_children():
		InputMap.erase_action("p" + str(Player.player_id) + "jump")
		InputMap.erase_action("p" + str(Player.player_id) + "ready")
		InputMap.erase_action("p" + str(Player.player_id) + "movement_left")
		InputMap.erase_action("p" + str(Player.player_id) + "movement_right")
		InputMap.erase_action("p" + str(Player.player_id) + "flip")
		InputMap.erase_action("p" + str(Player.player_id) + "ability")
	get_tree().change_scene("res://Worlds/Level.tscn")


func _on_IPGetter_request_completed(result, response_code, headers, body : PoolByteArray):
	Profile.public_ip = (body.get_string_from_ascii()).replace("\n", "")
