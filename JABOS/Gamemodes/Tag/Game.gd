extends Node2D

onready var Level = get_parent()
onready var Players = get_tree().get_nodes_in_group("Player")

var camera_speed = 5

const IT_PLAYER_SPEED = 2.5

var players_left : int
var leaderboard_data = {}

var is_singleplayer = false

var bg_color = Color.white

var Last_It : KinematicBody2D
var It_Player : KinematicBody2D

func _ready():
	$Level_Genorator.start()

func start():
	randomize()
	var it_selection = int(round(rand_range(0, Level.Manager.active_players.size() - 1)))
	
	print(it_selection)
	
	$Level_Genorator.load_part(0)
	Players = get_tree().get_nodes_in_group("Player")
	
	if players_left == 1:
		is_singleplayer = true
		
	for player in Players:
		leaderboard_data[player.player_id] = {}
		player.player_data["taggable"] = false
		player.player_data["it"] = false
		player.player_data["tags"] = 0
		if player.player_id == it_selection:
			It_Player = player
			It_Player.selected = true
			It_Player.connect("player_collision", self, "tag")
			It_Player.frozen = true
			$Cooldown.start(2)
			$KillTimer.start(25)
			
			It_Player.speed = IT_PLAYER_SPEED
			
			It_Player.player_data["it"] = true
		
func tag(new_it_player):
	if new_it_player.player_data["taggable"] and !new_it_player.is_respawning:
		
		It_Player.speed = It_Player.DEFAULT_SPEED
		
		$Tag.global_position = It_Player.global_position + Vector2(0, -100)
		$Tag/AnimationPlayer.play("Tag")
		
		Last_It = It_Player
		
		It_Player.player_data.tags += 1
		It_Player.player_data["it"] = false
		It_Player.player_data["taggable"] = false
		
		It_Player.disconnect("player_collision", self, "tag")
		It_Player.selected = false
		
		It_Player = new_it_player
		
		It_Player.selected = true
		It_Player.connect("player_collision", self, "tag")
		
		It_Player.speed = IT_PLAYER_SPEED
		
		It_Player.player_data["it"] = true
		It_Player.frozen = true
		
		$Cooldown.start(2)
		$KillTimer.start(15)
	else:
		It_Player.player_data["taggable"] = true

func _physics_process(delta):

	
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
			move = x.position.x - (Level.Game_Camera.position.x - 512)
			move = (move / Level.player_count) / 15
			Level.Game_Camera.position.x += (move)
			
	

	#For each player, check if they have gone off screen
	for player in Players:
		if player.position.y >= 1200:
			player.kill(true, true)
			


			
		#Update the leaderboard stats
		leaderboard(player.player_id, "Tags", player.player_data.tags)
		leaderboard(player.player_id, "Falls", player.falls)
		leaderboard(player.player_id, "Display", "Bool?=" + str(int(player.player_data["it"])) + "?=" + format_time($KillTimer.time_left) + "?=Not It")
		leaderboard(player.player_id, "Main", "Time:?=" + format_time(player.player_data.time))
# warning-ignore:integer_division
		leaderboard(player.player_id, "Ruby", int(player.player_data.tags) * 10)
		leaderboard(player.player_id, "XP", int(player.player_data.time) * 4)

		#If all players are dead, end the game
		if players_left == 0:
			end()

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


func _on_Cooldown_timeout():
	for player in Players:
		player.player_data["taggable"] = true
	It_Player.frozen = false


func _on_KillTimer_timeout():
	It_Player.kill(false)
	players_left -= 1
	leaderboard(It_Player.player_id, "Winner", false)

	if players_left == 1:
		for player in Players:
			if player.active:
				leaderboard(player.player_id, "Winner", true)
		end()
	else:
		tag(Last_It)
