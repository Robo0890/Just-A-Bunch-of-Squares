extends Control

var level = null
var allow_continue = false
var end = false
var random_time = 0

onready var player1 = $MarginContainer/VBoxContainer/Player1
onready var player2 = $MarginContainer/VBoxContainer/Player2
onready var player3 = $MarginContainer/VBoxContainer/Player3
onready var player4 = $MarginContainer/VBoxContainer/Player4


var player1time = ""
var player2time = ""
var player3time = ""
var player4time = ""

var ready_players = []

func _ready():
	$Panel/Label.text = "  Press        to Join"
	player1.visible = false
	player2.visible = false
	player3.visible = false
	player4.visible = false
	match Global.device:
		"mobile":
			$Panel/Label/Sprite.texture = load("res://GUI/Icons/up.png")
		"gamepad":
			$Panel/Label/Sprite.texture = load("res://GUI/Icons/buttonA.png")
		"pc":
			$Panel/Label/Sprite.texture = load("res://GUI/Icons/button1.png")
	level = get_parent().get_parent().get_parent()
	player1.visible = false
	player2.visible = false
	player3.visible = false
	player4.visible = false

# warning-ignore:unused_argument
func _process(delta):
	
	random_time += 1
	if random_time == 10:
		random_time = 0
	if !end:
		$"End Screen".visible = false
		$Panel.rect_size.y = 62 * level.active_players.size()
	if !level.start and !end:
		if level.active_players.size() > 0:
			$Panel/Label.text = "  Press        to Ready Up"
			match Global.device:
				"mobile":
					$Panel/Label/Sprite.texture = load("res://GUI/Icons/checkmark.png")
				"gamepad":
					$Panel/Label/Sprite.texture = load("res://GUI/Icons/buttonY.png")
				"pc":
					$Panel/Label/Sprite.texture = load("res://GUI/Icons/button3.png")
		for x in level.active_players:
			get("player" + str(x)).visible = true
			get("player" + str(x)).text = "Not Ready"
			get("player" + str(x)).modulate = Color(1,1,1,.5)
		for x in level.ready_players:
			get("player" + str(x)).modulate = Color(1,1,1,1)
			get("player" + str(x)).visible = true
			get("player" + str(x)).text = "Ready"
	elif !end:
		$Panel/Label.visible = false
		player1.self_modulate = Color.red
		player2.self_modulate = Color.red
		player3.self_modulate = Color.red
		player4.self_modulate = Color.red
		player1.modulate = Color(1,1,1,.3)
		player2.modulate = Color(1,1,1,.3)
		player3.modulate = Color(1,1,1,.3)
		player4.modulate = Color(1,1,1,.3)
		for x in level.alive_players:
			var time = level.time
			var seconds = 0
			var minutes = 0
			var miliseconds = 0
			seconds = str(time).split(".")[0]
			miliseconds = (time - (int(seconds) - 1)) * 10
			miliseconds = str(miliseconds) + str(random_time)
			miliseconds = str(miliseconds).right(1)
# warning-ignore:integer_division
			minutes = str(int(seconds)/60).split(".")[0]
			seconds = int(seconds) - int(minutes)*60
			if int(seconds) < 10:
				seconds = "0" + str(seconds)
			time = str(minutes) + ":" + str(seconds) + ":" + str(miliseconds)
			get("player" + str(x)).text = str(time)
			get("player" + str(x)).self_modulate = Color.green
			get("player" + str(x)).modulate = Color(1,1,1,1)
			set("player" + str(x) + "time", str(time))
	if end:
		match Global.device:
				"mobile":
					$Panel/Label/Sprite.texture = load("res://GUI/Icons/up.png")
					get_score_display(4,"Press A/TextureRect").texture = load("res://GUI/Icons/up.png")
				"gamepad":
					$Panel/Label/Sprite.texture = load("res://GUI/Icons/buttonA.png")
					for x in level.active_players:
						get_score_display(x,"Press A/TextureRect").texture = load("res://GUI/Icons/buttonA.png")
				"pc":
					$Panel/Label/Sprite.texture = load("res://GUI/Icons/button1.png")
					get_score_display(4,"Press A/TextureRect").texture = load("res://GUI/Icons/button1.png")
		$"End Screen".visible = true
		for x in level.active_players:
			get_score_display(x).visible = true
			if !level.player_scores[x].win:
				get_score_display(x,"Winner").text = ""
			get_score_display(x,"Falls").text = str(level.player_scores[x].falls) + " Falls"
			get_score_display(x,"Jumps").text = str(level.player_scores[x].jumps) + " Jumps"
			get_score_display(x,"Time").text = get("player" + str(x) + "time")
			if Input.is_action_just_pressed("p" + str(x) + "_movement_jump") and !ready_players.has(x) and allow_continue:
				ready_players.append(x)
				GameSound.play_sound("drop_001")
			if ready_players.has(x):
				get_score_display(x,"Press A/TextureRect").texture = load("res://GUI/Icons/checkmark.png")
				get_score_display(x).modulate = Color(1,1,1,.5)
		if ready_players.size() == level.active_players.size():
# warning-ignore:return_value_discarded
			get_tree().create_timer(1).connect("timeout", self,"_on_Timer_timeout")
			


func get_score_display(player,item = "") -> Object:
	return get_node("End Screen/HBoxContainer/Player" + str(player) + "/" + item)


func _on_Timer_timeout():
	get_parent().get_parent().reset()
