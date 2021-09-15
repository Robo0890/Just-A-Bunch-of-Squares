extends Control


onready var key = preload("res://GUI/Key.tscn")
var keyboard = "1234567890qwertyuiopasdfghjklzxcvbnm"

var player_name = "Steve"

func _ready():
	$Keyboard.visible = false
	for x in keyboard.length():
		x = keyboard[x]
		var k = key.instance()
		k.name = "Key_" + x
		k.text = str(x).capitalize()
		$Keyboard/Board.add_child(k)
	$Keyboard/Board.move_child($"Keyboard/Board/Key_Backspace",keyboard.length() + 1)
	$Keyboard/Board.move_child($"Keyboard/Board/Key_Enter",29)
	for x in $Keyboard/Board.get_children():
		x.connect("pressed", self, "key_pressed")
# warning-ignore:unused_argument
func _process(delta):
	$Keyboard/Label.text = player_name
	if Input.is_action_just_pressed("Menu_X"):
		if $Control/Profile/VBoxContainer/Name.visible:
			_on_Name_pressed()
		else:
			player_name.erase(player_name.length() - 1,1)
	

func key_pressed():
	var key_pressed
	for x in $Keyboard/Board.get_children():
		if x.pressed:
			key_pressed = str(x.name).split("_")[1]
			print(key_pressed)
			break
	if key_pressed == "Enter":
		$Keyboard.visible = false
		$Control/Profile/VBoxContainer/Name.visible = true
		$Control/Profile/VBoxContainer/Name.text = player_name
		return
	if key_pressed == "Backspace":
		player_name.erase(player_name.length() - 1,1)
	else:
		if player_name.length() < 9:
			player_name = player_name + key_pressed


func _on_Name_pressed():
	$Keyboard.visible = true
	$Control/Profile/VBoxContainer/Name.visible = false
	$Keyboard/Board.get_child(0).grab_focus()
