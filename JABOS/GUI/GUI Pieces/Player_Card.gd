extends Panel


var Player : KinematicBody2D
var Level : Node
var Ruby_Count : Node2D

var data = {}
var ready = false

func _ready():
	if Player.input_method == "Touch":
		$Ok.texture_normal = load("res://GUI/Icons/gameicons/PNG/White/1x/up.png")
		
	$MarginContainer/Info/PlayerImage.texture = load("res://Images/Skins/" + Player.skin + ".png")
	$MarginContainer/Info/ImageMask.texture = load("res://Images/Skins/mask." + Player.skin + ".png")
	$MarginContainer/Info/ImageMask.modulate = Player.color
	
	$"MarginContainer/Info/Main Score".text = str(data.Main).split("?=")[1]
	$Winner.visible = data.Winner
	$Particles/Gold.emitting = data.Winner
	$Rewards/Rubies.text = "+" + str(data.Ruby)
	$Rewards/XP.text = "XP +" + str(data.XP)
	
	$MarginContainer/Info/MainScoreLabel.text = str(data.Main).split("?=")[0]

	if data.Ruby < 1:
		$Rewards/Rubies.add_color_override("font_color", Color.red)
	else:
		$Particles/Rubies.emitting = true
	if data.XP < 1:
		$Rewards/XP.add_color_override("font_color", Color.red)
	else:
		$Particles/XP.emitting = true

	for score in data.keys():
		if !["Main", "Winner", "Ruby", "XP", "Display"].has(score):
			var label = $MarginContainer/Info/Subscore.duplicate()
			label.name = score
			label.text = score + ": " + str(data[score])
			$MarginContainer/Info.add_child(label)
		if score == "Ruby":
			Profile.data.ruby += data.Ruby
		if score == "XP":
			Profile.data.xp += data.XP
	$MarginContainer/Info/Subscore.queue_free()
	$MarginContainer/Info/Subscore2.queue_free()
	$MarginContainer/Info.move_child($MarginContainer/Info/Bottom, $MarginContainer/Info.get_child_count())

	yield(get_tree().create_timer(1),"timeout")
	ready = true

func _process(delta):
	if ready:
		if Input.is_action_just_pressed("p" + str(Player.player_id) + "jump"):
			modulate = Color(1,1,1,.7)
			$Ok.disabled = true
			Level.ready_players.append(Player.player_id)
			print("p" + str(Player.player_id) + "jump")


