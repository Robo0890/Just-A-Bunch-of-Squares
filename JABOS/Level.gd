extends Node2D

var start = false
var players = 0

var time = 0

var active_players = []
var ready_players = []
var alive_players = []

var player_scores = {}

onready var basic_jump = preload("res://Sections/Basic Jump.tscn")
onready var hook = preload("res://Sections/Hook.tscn")
onready var small_jumps = preload("res://Sections/Small Jumps.tscn")
onready var wall = preload("res://Sections/Wall.tscn")
onready var split_direction = preload("res://Sections/Split Direction.tscn")
onready var stick = preload("res://Sections/Stick.tscn")

onready var player = preload("res://Player/Player2D.tscn")
 
var sections = 6


func _ready():
	OS.set_window_title("Just A Bunch of Squares")
	GameSound.play_sound("maximize_006")
	if Global.is_up_to_date():
		$Camera/Control/News.visible = false
	else:
		$Camera/Control/News.visible = true

func add_player(player_number):
	GameSound.play_sound("drop_003")
	active_players.append(player_number)
	players += 1
	var p = player.instance()
	p.position = Vector2(0,-200)
	p.player_name = "p" + str(player_number) + "_"
	p.color = .4 * (player_number - 1)
	p.player = player_number
	player_scores[player_number] = {}
	player_scores[player_number].win = false
	player_scores[player_number].jumps = 0
	player_scores[player_number].falls = 0
	player_scores[player_number].time = "-:--:--"
	add_child(p)


func load_section():
	var s = null
	randomize()
	var pick = int(rand_range(1,sections + 1))
	match pick:
		1:
			s = basic_jump.instance()
		2:
			s = hook.instance()
		3:
			s = small_jumps.instance()
		4:
			s = wall.instance()
		5:
			s = split_direction.instance()
		6:
			s = stick.instance()
	s.position = $Camera.position + Vector2(800,0)
	$Sections.add_child(s)
	
	

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and $Camera/Control/News.visible:
		_on_Button_pressed()
	if !$"Camera/Control/GuiHandler/End Screen".visible and !$Camera/Control/News.visible:
		if Input.is_action_just_pressed("p1_movement_jump") and !start and !active_players.has(1):
			add_player(1)
		if Input.is_action_just_pressed("p2_movement_jump") and !start and !active_players.has(2):
			add_player(2)
		if Input.is_action_just_pressed("p3_movement_jump") and !start and !active_players.has(3):
			add_player(3)
		if Input.is_action_just_pressed("p4_movement_jump") and !start and !active_players.has(4):
			add_player(4)
	for x in active_players:
		if Input.is_action_just_pressed("p" + str(x) + "_ready") and !start and !ready_players.has(x):
			ready_players.append(x)
			GameSound.play_sound("drop_004")
		elif Input.is_action_just_pressed("p" + str(x) + "_ready") and !start and ready_players.has(x):
			ready_players.erase(x)
			GameSound.play_sound("bong_001")
	if ready_players.size() == active_players.size() and active_players != [] and !start:
		start = true
		alive_players = ready_players
		$Timer.start()
		if active_players.size() == 1:
			OS.set_window_title("Just A Bunch of Squares - In Single Player Game")
		else:
			OS.set_window_title("Just A Bunch of Squares - In " + str(active_players.size()) + " Player Game")



# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Front_Edge_area_shape_exited(area_id, area, area_shape, local_shape):
	if area.name == "end_of_section":
		call_deferred("load_section")
		area.queue_free()


func _on_Timer_timeout():
	time += .1
	$Timer.start()


func _on_Button_pressed():
	$Camera/Control/News.visible = false