extends Node


var ready_players = []
var game_state = "Lobby"
var gamemode = "Classic"

onready var Game : Object
onready var Classic = preload("res://Gamemodes/Classic/Classic.tscn")
onready var Floor_Is_Lava = preload("res://Gamemodes/Floor Is Lava/Floor Is Lava.tscn")
onready var Space_Jump = preload("res://Gamemodes/Classic/Classic.tscn")

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
	game_state = "Playing"
	Game.players_left = $Manager.get_child_count()
	for x in $Manager.get_children():
		x.active = true
	
func end_game(leaderboard : Dictionary):
	print(leaderboard)
	for x in $Manager.get_children():
		x.active = false
		x.frozen = true
	game_state = "End"

func change_gamemode(gamemode : String):
	#Game.queue_free()
	gamemode = gamemode.replace(" ", "_")
	Game = get(gamemode).instance()
	add_child(Game)
