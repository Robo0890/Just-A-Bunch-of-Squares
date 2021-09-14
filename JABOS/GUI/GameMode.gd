extends Control

var hovered = "Classic"

func _ready():
	if Global.cloudcode != null:
		$JoinGame.visible = true
		$JoinGame/Panel/VBoxContainer/Code.text = Global.cloudcode
		$JoinGame/Panel/Ok.grab_focus()
	$"MarginContainer/VBoxContainer/Classic/Panel".grab_focus()
	GameSound.play_sound("question_002")

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
		hovered = "FloorIsLava"
	match hovered:
		"Classic":
			$Background/Classic.modulate.a = lerp($Background/Classic.modulate.a,1,.09)
			$Background/FloorIsLava.modulate.a = lerp($Background/FloorIsLava.modulate.a,0,.09)
		"FloorIsLava":
			$Background/Classic.modulate.a = lerp($Background/Classic.modulate.a,0,.09)
			$Background/FloorIsLava.modulate.a = lerp($Background/FloorIsLava.modulate.a,1,.09)


func _on_Panel_pressed():
	GameSound.play_sound("confirmation_001")
	$MarginContainer/AnimationPlayer.play("Fade")


# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://" + hovered + "/Level.tscn")


func _on_Ok_pressed():
	pass # Replace with function body.
