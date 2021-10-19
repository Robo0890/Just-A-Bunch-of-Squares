extends Node2D

onready var Level = get_parent()
onready var Players = get_tree().get_nodes_in_group("Player")

var camera_speed = 5

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
	$Edge.position = Level.Game_Camera.position - Vector2(get_viewport_rect().size.x + 50,0)
	match Level.game_state:
		"Playing":
			game_tick()

func game_tick():
	var move = 0
	for x in get_tree().get_nodes_in_group("Player"):
		move += x.position.x - Level.Game_Camera.position.x
		move = ((move / Level.player_count) / 100) + 32
		Level.Game_Camera.position.x += (move/4) + (.0004 * Level.Game_Camera.position.x)

	
	for player in Players:
		if player.position.y >= 1200:
			player.kill(true)
		if player.position.x <= $Edge.global_position.x - 512:
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



func on_player_offscreen(body):
	if body.is_in_group("Player") and Level.game_state == "Playing":
		body.kill(false)
		players_left -= 1
