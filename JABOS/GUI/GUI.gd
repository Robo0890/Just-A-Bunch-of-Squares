extends Control

onready var Level = get_parent().get_parent()

onready var Options = $Options
onready var Animator = $AnimationPlayer
onready var PlayerList = $Top_UI/Panel/VBoxContainer
onready var PlayerManagerList = $PlayerManager/MarginContainer/VBoxContainer/Players

onready var GamemodeBox = $Options/VBoxContainer/MarginContainer/GridContainer/GameMode
onready var XpBar = $Leaderboard/Control/Profile/Profile/HBoxContainer/ProgressBar

onready var PlayerTag = preload("res://GUI/GUI Pieces/Player_Tag.tscn")
onready var PlayerCard = preload("res://GUI/GUI Pieces/Player_Card.tscn")
onready var PlayerManager = preload("res://GUI/GUI Pieces/Player_Manager.tscn")
onready var Shop = preload("res://Shop/Shop.tscn")

var Shop_Obj : Control

var ui_focus = "none"

func get_gamemodes():
	var path = "res://Gamemodes/"
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files


func _input(event):
	if event is InputEventScreenTouch:
		if !Level.Manager.connected_devices.has("Mobile") and Level.Manager.ready and !Profile.touch_disabled:
			activate_mobile()
	if event.is_action("options"):
		if !event.pressed:
			match ui_focus == "Options":
				false:
					_on_Button_pressed()
				true:
					_on_TextureButton_pressed()
	if event.is_action("ui_cancel"):
		if !event.pressed:
			match ui_focus:
				"Options":
					_on_TextureButton_pressed()
				"Manage":
					_on_Close_pressed()
				"Shop":
					Shop_Obj._on_Back_pressed()
					_on_TextureButton_pressed()
					

func _ready():
	
	if OS.get_name() != "HTML5":
		$Options/VBoxContainer/MarginContainer/GridContainer/CreateCloud.add_icon_item(load("res://GUI/Icons/gameicons-expansion/PNG/White/1x/cloud.png"), "Create")
		
	var popup = GamemodeBox.get_popup()
	var gamemode_list = get_gamemodes()
	
	for x in gamemode_list:
		if true:#Profile.data.Owned.Gamemodes.has(x):
			var path = "res://Gamemodes/" + x 
			var new_item_name = x
			var new_item_icon = load(path + "/Images/Icon.png")
			popup.add_icon_item(new_item_icon, new_item_name)
			
	
	for x in get_tree().get_nodes_in_group("Cloud_Only"):
		x.visible = false
		
	
	

func _physics_process(delta):
	
	if Level.Manager.connected_devices.has("Mobile"):
		$Options/VBoxContainer/MarginContainer/GridContainer/Touch.visible = true
		$Options/VBoxContainer/MarginContainer/GridContainer/Mobile.visible = true
	
	$Top_UI/Panel.rect_size.y = (PlayerList.get_child_count() - 1) * 55
	match Level.game_state:
		"Playing":
			$Top_UI/Option_Button.hide()
			$Top_UI/Panel/VBoxContainer/Join_Prompt.hide()
			$Leaderboard.hide()
			$Options.hide()
		"Lobby":
			$Top_UI.show()
			$Leaderboard.hide()
			$Top_UI/Panel.show()
			$Top_UI/Option_Button.show()
			$Top_UI/Panel/VBoxContainer/Join_Prompt.show()
			$Leaderboard.hide()
			XpBar.value = Profile.data.xp
			$Options/VBoxContainer/MarginContainer/GridContainer/Pin.text = str(Level.Cloud.game_pin)
		"End":
			$Top_UI/Panel.hide()
			if !$Leaderboard.visible:
				show_leaderboard()
				$Leaderboard.show()
			XpBar.value = lerp(XpBar.value, Profile.data.xp, .1)
			
			$Leaderboard/Control/Profile/Rubies.text = str(Profile.data.ruby)
			$Leaderboard/Control/Profile/Profile/HBoxContainer/ProgressBar/Level/Label.text = "Level " + str(Profile.data.level)
			XpBar.max_value = Profile.xp_for_next_level()
			
			$Leaderboard/Control/Profile/Profile/HBoxContainer/ProgressBar/Level/XP.text = "XP " + str(Profile.data.xp) + "/" + str(Profile.xp_for_next_level())
			



func player_join(player):
	if player.input_method == "Touch":
		$"Bottom_UI/Mobile Controller".Level = Level
		$"Bottom_UI/Mobile Controller".visible = true
		$"Bottom_UI/Mobile Controller".player_id = player.player_id

	var p = PlayerTag.instance()
	p.name = "Player_" + str(player.player_id)
	p.Player = player
	p.Level = Level
	p.Game = Level.Game
	PlayerList.add_child(p)
	PlayerList.move_child($Top_UI/Panel/VBoxContainer/Join_Prompt, PlayerList.get_child_count())

	var m = PlayerManager.instance()
	m.Player = p.Player
	m.name = "Player" + str(p.Player.player_id)
	PlayerManagerList.add_child(m)
	


func show_leaderboard():
	for player in Level.Game.Players:
		var c = PlayerCard.instance()
		c.name = "Player" + str(player.player_id)
		c.Player = player
		c.Level = Level
		c.data = Level.leaderboard_data[player.player_id]
		$Leaderboard/Cards.add_child(c)

func _on_TextureButton_pressed():
	ui_focus = "none"
	Animator.play_backwards("Options")
	UIAudio.play_sound("click2")
	$Top_UI/Dummy.grab_focus()


func _on_Button_pressed():
	ui_focus = "Options"
	Animator.play("Options")
	UIAudio.play_sound("click1")
	$Options/VBoxContainer/MarginContainer/GridContainer/GameMode.grab_focus()



func _ui_click():
	UIAudio.play_sound("click1")


func _ui_click_select(index):
	UIAudio.play_sound("click4")
	


func _on_gamemode_selected(index):
	var item_name = GamemodeBox.get_item_text(index)
	Level.change_gamemode(item_name)





func activate_mobile():
	Level.Manager.connected_devices.append("Mobile")
	Level.Manager.add_player(Level.Manager.active_players.size(), "Mobile", "Touch")




func _on_Pin_pressed():
	JavaScript.eval("""
	const shareData = {
		title: "JABOS Cloud Invite",
		url: "https://robo0890.github.io/Just-A-Bunch-of-Squares/Join?code=""" + $Options/VBoxContainer/MarginContainer/GridContainer/Pin.text +""""
	}
	navigator.share(shareData)
	""")




func _on_CreateCloud_item_selected(index):
	$Options/VBoxContainer/MarginContainer/GridContainer/GamePin.show()
	if index == 1:
		Level.Cloud.create_game()
		$Options/VBoxContainer/MarginContainer/GridContainer/JoinPin.hide()
		$Options/VBoxContainer/MarginContainer/GridContainer/Pin.show()
	if index == 0:
		$Options/VBoxContainer/MarginContainer/GridContainer/Pin.hide()
		$Options/VBoxContainer/MarginContainer/GridContainer/JoinPin.show()


func _on_JoinPin_text_entered(new_text):
	$Options/VBoxContainer/MarginContainer/GridContainer/JoinPin/Loading.visible = true
	Level.Cloud.join_game(new_text)

func join_err(err):
	$Options/VBoxContainer/MarginContainer/GridContainer/JoinPin/Loading.visible = false
	if err == "Connected! ":
		return
	$Options/VBoxContainer/MarginContainer/GridContainer/JoinPin/Err.text = err
	$Options/VBoxContainer/MarginContainer/GridContainer/JoinPin/Err.show()
	yield(get_tree().create_timer(2), "timeout")
	$Options/VBoxContainer/MarginContainer/GridContainer/JoinPin/Err.hide()


func _on_Shop_pressed():
	_on_TextureButton_pressed()
	hide()
	var s = Shop.instance()
	Level.GUI.get_parent().add_child(s)
	Shop_Obj = s
	ui_focus = "Shop"


func _on_Close_pressed():
	$PlayerManager.hide()
	$Options.show()
	Animator.play("Options")
	UIAudio.play_sound("click1")
	ui_focus = "Options"
	


func _on_Players_pressed():
	$Options.hide()
	$PlayerManager.show()
	ui_focus = "Manage"
	$PlayerManager/MarginContainer/VBoxContainer/Close.grab_focus()


func _on_Touch_item_selected(index):
	Profile.touch_disabled = bool(index)
	$"Bottom_UI/Mobile Controller".visible = !Profile.touch_disabled
	print(Profile.touch_disabled)
	
