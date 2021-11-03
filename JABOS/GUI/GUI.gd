extends Control

onready var Level = get_parent().get_parent()

onready var Options = $Options
onready var Animator = $AnimationPlayer
onready var NameBox = $Options/VBoxContainer/MarginContainer/GridContainer/LineEdit
onready var PlayerList = $Top_UI/Panel/VBoxContainer

onready var GamemodeBox = $Options/VBoxContainer/MarginContainer/GridContainer/GameMode
onready var XpBar = $Leaderboard/Control/Profile/Profile/HBoxContainer/ProgressBar

onready var PlayerTag = preload("res://GUI/GUI Pieces/Player_Tag.tscn")
onready var PlayerCard = preload("res://GUI/GUI Pieces/Player_Card.tscn")
onready var Shop = preload("res://Shop/Shop.tscn")

var is_shop_visible = false

func _ready():
	var popup = GamemodeBox.get_popup()
	popup.add_separator("")
	popup.add_item("Shop")
	popup.set_item_icon(popup.get_item_count() - 1, load("res://GUI/Icons/gameicons/PNG/White/1x/basket.png"))
	
	for x in get_tree().get_nodes_in_group("Cloud_Only"):
		x.visible = false

func _physics_process(delta):
	$Top_UI/Panel.rect_size.y = (PlayerList.get_child_count() - 1) * 55
	match Level.game_state:
		"Playing":
			$Top_UI/Option_Button.hide()
			$Top_UI/Panel/VBoxContainer/Join_Prompt.hide()
			$Leaderboard.hide()
		"Lobby":
			$Top_UI.show()
			$Leaderboard.hide()
			$Top_UI/Panel.show()
			$Top_UI/Option_Button.show()
			$Top_UI/Panel/VBoxContainer/Join_Prompt.show()
			$Leaderboard.hide()
			XpBar.value = Profile.data.xp
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
	var p = PlayerTag.instance()
	p.name = "Player_" + str(player.player_id)
	p.Player = player
	p.Level = Level
	p.Game = Level.Game
	PlayerList.add_child(p)
	PlayerList.move_child($Top_UI/Panel/VBoxContainer/Join_Prompt, PlayerList.get_child_count())

func show_leaderboard():
	for player in Level.Game.Players:
		var c = PlayerCard.instance()
		c.name = "Player" + str(player.player_id)
		c.Player = player
		c.Level = Level
		c.data = Level.leaderboard_data[player.player_id]
		$Leaderboard/Cards.add_child(c)

func _on_TextureButton_pressed():
	Animator.play_backwards("Options")
	UIAudio.play_sound("click2")


func _on_Button_pressed():
	Animator.play("Options")
	UIAudio.play_sound("click1")



func _ui_click():
	UIAudio.play_sound("click1")


func _ui_click_select(index):
	UIAudio.play_sound("click4")
	



func _on_GameType_item_selected(index):
	for x in get_tree().get_nodes_in_group("Cloud_Only"):
		x.visible = index


func _on_gamemode_selected(index):
	var item_name = GamemodeBox.get_item_text(index)
	if item_name != "Shop":
		Level.change_gamemode(item_name)
	else:
		_on_TextureButton_pressed()
		hide()
		var s = Shop.instance()
		Level.GUI.get_parent().add_child(s)
		is_shop_visible = true







func _on_Mobile_Detection_pressed():
	$"Bottom_UI/Mobile Contoller".Level = Level
	$"Bottom_UI/Mobile Contoller".visible = true
	Level.Manager.connected_devices.append("Mobile")
	$"Bottom_UI/Mobile Contoller".player_id = Level.Manager.add_player(Level.Manager.active_players.size(), "Mobile", "Touch").player_id
	$"Mobile Detection".queue_free()

