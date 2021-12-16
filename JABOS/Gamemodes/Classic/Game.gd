extends Node2D

onready var Level = get_parent()
onready var Players = get_tree().get_nodes_in_group("Player")

var camera_speed = 5

var players_left : int
var leaderboard_data = {}

var is_singleplayer = true




func _ready():
	$Level_Genorator.start()

func start():
	$Level_Genorator.load_part(0)
	Players = get_tree().get_nodes_in_group("Player")
	
	if players_left == 1:
		is_singleplayer = true
		
	for player in Players:
		player.connect("killed", self, "remove_player")
		leaderboard_data[player.player_id] = {}
		leaderboard(player.player_id, "Winner", false)

func _physics_process(delta):
	#Move the edge indicator to the left border of the window
	$Edge.position = Level.Game_Camera.position - Vector2(get_viewport_rect().size.x + 50,0)
	
	#Change the values of players
	set_all_players("gravity", null)
	set_all_players("max_jumps", null)
	
	match Level.game_state:
		"Playing": #If the game is playing, then run game_tick function
			game_tick()


#Run for every frame while game is playing
func game_tick():
	
	#Move the game camera
	var move = 0
	for x in get_tree().get_nodes_in_group("Player"):
		if x.active:
			move += x.position.x - Level.Game_Camera.position.x
			move = (move / Level.player_count) / 75 + 32
	Level.Game_Camera.position.x += (move/4) + (.0001 * Level.Game_Camera.position.x)

	#For each player, check if they have gone off screen
	for player in Players:
		if player.position.y >= 1200:
			player.kill(true, true)
			
		#Using the edge indicator from above, determine wether a player is offscreen
		if player.position.x <= $Edge.global_position.x - 512 and player.active:
			player.kill(false)

		#Update the leaderboard stats
		leaderboard(player.player_id, "Falls", player.falls)
		leaderboard(player.player_id, "Jumps", player.jump_count)
		leaderboard(player.player_id, "Display", "Text?=" + format_time(player.player_data.time) + "?=null")
		leaderboard(player.player_id, "Main", "Time:?=" + format_time(player.player_data.time))
# warning-ignore:integer_division
		leaderboard(player.player_id, "Ruby", int(player.player_data.time) / 2)
		leaderboard(player.player_id, "XP", int(player.player_data.time) * 2)

func end():
	#Tell the Level scene that the game is over
	Level.end_game(leaderboard_data)

#Set player leaderboard stat
func leaderboard(who : int, key : String, value):
	leaderboard_data[who][key] = value

#Set variable for all players
func set_all_players(what : String, to_what):
	Players = get_tree().get_nodes_in_group("Player")
	if Players.size() > 0:
		if to_what == null:
			to_what = Players[0].get("DEFAULT_" + what.to_upper())
		for player in Players:
			player.set(what, to_what)
			
			
			
func remove_player(player):
	players_left -= 1
			
	#If that player is the last one remaining:
	if players_left == 0:
	#Player is winner
		leaderboard(player.player_id, "Winner", true)
	else:
	#Player did not win
		leaderboard(player.player_id, "Winner", false)
		
	#If all players are dead, end the game
	if players_left == 0:
		end()


#Get value of given player by id
func get_player(id : int, what : String):
	Players = get_tree().get_nodes_in_group("Player")
	if Players.size() > 0:
		for player in Players:
			if player.player_id == id:
				return player.get(what)

#Format the number of seconds into minutes, seconds, and miliseconds (EX: 0:00:00)
func format_time(input_seconds):
	# warning-ignore:integer_division
	var minutes = str(int(input_seconds) / 60)
	var seconds = str(int(input_seconds - (int(minutes) * 60)))
	var miliseconds = str(int((input_seconds - int(seconds)) * 100))
	miliseconds =  str(int(miliseconds) - (int(minutes) * 6000))
	
	if int(seconds) < 10:
		seconds = "0" + seconds
	
	return minutes + ":" + seconds + ":" + miliseconds

#Get the current score of a player by their id
func get_display_score(player):
	return leaderboard_data[player].Display
