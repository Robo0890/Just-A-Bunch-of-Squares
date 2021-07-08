extends Control



func _ready():
	if !Global.splashed:
		$Background/AnimationPlayer.play("EonSplash")
		$MarginContainer.hide()
		yield(get_tree().create_timer(.3),"timeout")
		GameSound.play_sound("confirmation_001")
		Global.splashed = true
	else:
		$MarginContainer.show()
		$Touch.grab_focus()
		$SplashLogo.queue_free()
		GameSound.play_sound("question_002")

# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "EonSplash":
		$MarginContainer.show()
		$Touch.grab_focus()
		$SplashLogo.queue_free()
		GameSound.play_sound("question_002")
	if anim_name == "Fade":
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Level.tscn")
	


func _on_Touch_pressed():
	GameSound.play_sound("select_003")
	Global.device = "mobile"
	$Touch.hide()
	$Background/AnimationPlayer.play("Fade")
	


func _on_PC_pressed():
	GameSound.play_sound("select_003")
	Global.device = "pc"
	$PC.hide()
	$Background/AnimationPlayer.play("Fade")


func _on_GamePad_pressed():
	GameSound.play_sound("select_003")
	Global.device = "gamepad"
	$GamePad.hide()
	$Background/AnimationPlayer.play("Fade")



func _on_GamePad_focus_entered():
	GameSound.play_sound("pluck_001")


func _on_PC_focus_entered():
	GameSound.play_sound("pluck_001")


func _on_Touch_focus_entered():
	GameSound.play_sound("pluck_001")
