extends Node


var ready_players = []
var game_state = "Lobby"
var gamemode = "Classic"

var player_count : int

onready var Game_Object = get_tree().get_nodes_in_group("Game")[0]
onready var Game_Camera = $Camera

onready var Game : Object
onready var Classic = preload("res://Gamemodes/Classic/Game.tscn")
onready var Floor_Is_Lava = preload("res://Gamemodes/Floor Is Lava/Game.tscn")
onready var Space_Jump = preload("res://Gamemodes/Space Jump/Game.tscn")

func _ready():
	change_gamemode("Classic")

func _physics_process(delta):
	
	match game_state:
		"Lobby":
			if ready_players.size() == $Manager.get_child_count() and $Manager.get_child_count() != 0:
				game_start()

		"Playing":
			$Camera.zoom = lerp($Camera.zoom, Vector2(2,2), .1)
			
		"End":
			$Camera.zoom = lerp($Camera.zoom, Vector2(1,1), .1)

func game_start():
	player_count = $Manager.get_child_count()
	Game_Object = get_tree().get_nodes_in_group("Game")[0]
	game_state = "Playing"
	Game_Object.players_left = player_count
	Game_Object.start()
	for x in $Manager.get_children():
		x.active = true
	
func end_game(leaderboard : Dictionary):
	print(leaderboard)
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
	
