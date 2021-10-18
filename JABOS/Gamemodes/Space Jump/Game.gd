extends Node2D

onready var Level = get_parent()
onready var Players = get_tree().get_nodes_in_group("Player")


var players_left : int
var leaderboard_data = {}

var is_singleplayer = false

func _ready():
	$Level_Genorator.gamemode = "Classic"

func start():
	$Level_Genorator.load_part(0)
	Players = get_tree().get_nodes_in_group("Player")
	
	if players_left == 1:
		is_singleplayer = true
		
	for player in Players:
		leaderboard_data[player.player_id] = {}

func _physics_process(delta):
	match Level.game_state:
		"Playing":
			game_tick()

func game_tick():
	Level.Game_Camera.transform.origin.x += 8
	$Stars.position = Level.Game_Camera.position
	$Stars.gravity.x = -8
	
	for player in Players:
		if player.position.y >= 1200:
			player.kill(false)
			players_left -= 1
			if players_left == 0:
				leaderboard(player.player_id, "Winner", true)
			else:
				leaderboard(player.player_id, "Winner", true)

		leaderboard(player.player_id, "Falls", player.falls)
		leaderboard(player.player_id, "Jumps", player.jump_count)
		leaderboard(player.player_id, "Time", player.time)

		if players_left == 0:
			end()

func end():
	Level.end_game(leaderboard_data)

func leaderboard(who : int, key : String, value):
	leaderboard_data[who][key] = value

