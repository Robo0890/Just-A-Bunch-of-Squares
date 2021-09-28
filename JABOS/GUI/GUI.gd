extends Control

onready var Level = get_parent().get_parent()

onready var Options = $Options
onready var Animator = $AnimationPlayer
onready var NameBox = $Options/VBoxContainer/MarginContainer/GridContainer/LineEdit
onready var PlayerList = $Top_UI/Panel/VBoxContainer

onready var PlayerReady = preload("res://GUI/GUI Pieces/Player_Ready.tscn")

func _ready():
	for x in get_tree().get_nodes_in_group("Cloud_Only"):
		x.visible = false

func _physics_process(delta):
	$Top_UI/Panel.rect_size.y = (PlayerList.get_child_count() - 1) * 55
	match Level.game_state:
		"Playing":
			$Top_UI/Panel.hide()
			$Top_UI/Option_Button.hide()
		"Lobby":
			$Top_UI/Panel.show()
			$Top_UI/Option_Button.show()
		"End":
			pass
	

func player_join(player):
	var p = PlayerReady.instance()
	p.name = "Player_" + str(player.player_id)
	p.player = player
	PlayerList.add_child(p)
	
	PlayerList.move_child($Top_UI/Panel/VBoxContainer/Join_Prompt, PlayerList.get_child_count())

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
	Level.change_gamemode($Options/VBoxContainer/MarginContainer/GridContainer/GameMode.get_item_text(index))
