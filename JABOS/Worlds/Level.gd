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

onready var Game : Object
onready var Classic = preload("res://Gamemodes/Classic/Game.tscn")
#onready var Floor_Is_Lava = preload("res://Gamemodes/Floor Is Lava/Game.tscn")
#onready var Space_Jump = preload("res://Gamemodes/Space Jump/Game.tscn")

func _ready():
	get_tree().debug_collisions_hint = true
	
	change_gamemode("Classic")
	var load_data = Save.load_data("jabos_profile")
	if load_data.size() > 0:
		print(load_data)
		Profile.data = load_data
	else:
		Profile.clear()
		

func _physics_process(delta):
	match game_state:
		"Lobby":
			for player in $Manager.get_children():
				if player.position.y >= 1200:
					player.kill(true, true)
			
			if GUI.is_shop_visible:
				$Camera.position = lerp($Camera.position, Vector2(1024,300), .1)
			else:
				$Camera.position = lerp($Camera.position, Vector2(512,300), .1)
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
	player_count = $Manager.get_child_count()
	Game_Object = get_tree().get_nodes_in_group("Game")[0]
	game_state = "Playing"
	Game_Object.players_left = player_count
	Game_Object.start()
	for x in $Manager.get_children():
		x.active = true
	
func end_game(leaderboard : Dictionary):
	ready_players = []
	leaderboard_data = leaderboard
	for x in $Manager.get_children():
		x.active = false
		x.frozen = true
	game_state = "End"

func change_gamemode(new_gamemode : String):
	get_tree().get_nodes_in_group("Game")[0].queue_free()
	gamemode = new_gamemode
	new_gamemode = new_gamemode.replace(" ", "_")
	Game = get(new_gamemode).instance()
	add_child(Game)

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
	get_tree().change_scene("res://Worlds/Level.tscn")
