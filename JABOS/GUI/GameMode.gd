extends Control

var hovered = "Classic"

func _ready():
	if Global.cloudcode != null:
		$JoinGame.visible = true
		$JoinGame/Panel/VBoxContainer/Code.text = Global.cloudcode
		$JoinGame/Panel/Ok.grab_focus()
	$"MarginContainer/VBoxContainer/Classic/Panel".grab_focus()
	GameSound.play_sound("question_002")
	$MarginContainer.visible = true
	$MarginContainer2.visible = false
# warning-ignore:unused_argument



func _process(delta):
	$JoinGame/Clouds.position = Vector2(860,640)
	$JoinGame/Clouds.position += get_global_mouse_position()/35
	$JoinGame/Panel/VBoxContainer.rect_position = Vector2(15,-15)
	$JoinGame/Panel/VBoxContainer.rect_position -= get_global_mouse_position()/70
	
	
	$Background/Classic/Move.position.x -= 4
	$Background/FloorIsLava/Move.position.y += 4
	if $Background/Classic/Move.position.x == -3080:
		$Background/Classic/Move.position.x = 0
	if $Background/FloorIsLava/Move.position.y == 1560:
		$Background/FloorIsLava/Move.position.y = 0
	if $MarginContainer/VBoxContainer/Classic/Panel.is_hovered():
		hovered = "Classic"
	if $"MarginContainer/VBoxContainer/Floor is Lava/Panel".is_hovered():
		hovered = "Floor Is Lava"
	if $MarginContainer2/VBoxContainer/Gamemode/HBoxContainer2/Local.is_hovered():
		$MarginContainer2/VBoxContainer/Info.text = "Local Multiplayer - Play with friends on the same device"
	elif $MarginContainer2/VBoxContainer/Gamemode/HBoxContainer2/Cloud.is_hovered():
		$MarginContainer2/VBoxContainer/Info.text = "Cloud Multiplayer - Coming Soon!"
	else:
		match hovered:
			"Classic":
				$MarginContainer2/VBoxContainer/Info.text = "Classic - Be the last one to fall victum to \nthe edge of the screen"
			"Floor Is Lava":
				$MarginContainer2/VBoxContainer/Info.text = "Floor Is Lava - Be the last one to fall!"
	match hovered:
		"Classic":
			$Background/Classic.modulate.a = lerp($Background/Classic.modulate.a,1,.09)
			$Background/FloorIsLava.modulate.a = lerp($Background/FloorIsLava.modulate.a,0,.09)
		"Floor Is Lava":
			$Background/Classic.modulate.a = lerp($Background/Classic.modulate.a,0,.09)
			$Background/FloorIsLava.modulate.a = lerp($Background/FloorIsLava.modulate.a,1,.09)


func _on_Panel_pressed():
	$MarginContainer.visible = false
	$MarginContainer2.visible = true
	$MarginContainer2/VBoxContainer/Gamemode/Back/Label.text = hovered
	$MarginContainer2/VBoxContainer/Gamemode/Back.grab_focus()
	


# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://" + hovered.replace(" ", "") + "/Level.tscn")


func _on_Ok_pressed():
	get_tree().change_scene("res://Cloud Game/Cloud Lobby.tscn")


func _on_No_pressed():
	$JoinGame.visible = false


func _on_Back_pressed():
	$MarginContainer.visible = true
	$MarginContainer2.visible = false
	match hovered:
		"Classic":
			$MarginContainer/VBoxContainer.get_child(0).get_child(0).grab_focus()
		"Floor Is Lava":
			$MarginContainer/VBoxContainer.get_child(1).get_child(0).grab_focus()


func _on_Local_pressed():
	GameSound.play_sound("confirmation_001")
	$MarginContainer/AnimationPlayer.play("Fade")


func _on_Cloud_pressed():
	pass # Replace with function body.
