extends Control

var focused = false

func _ready():
	$Touch.hide()
	$PC.hide()
	$GamePad.hide()
	if !Global.splashed:
		$Background/AnimationPlayer.play("EonSplash")
		$MarginContainer.hide()
		yield(get_tree().create_timer(.3),"timeout")
		GameSound.play_sound("confirmation_001")
		Global.splashed = true
	else:
		get_tree().change_scene("res://GUI/GameMode.tscn")
		$MarginContainer.show()
		$SplashLogo.queue_free()
		GameSound.play_sound("question_002")
		$Touch.show()
		$PC.show()
		$GamePad.show()

# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "EonSplash":
		get_tree().change_scene("res://GUI/GameMode.tscn")
		$MarginContainer.show()
		$SplashLogo.queue_free()
		GameSound.play_sound("question_002")
		$Touch.show()
		$PC.show()
		$GamePad.show()
	if anim_name == "Fade":
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://GUI/GameMode.tscn")

func _input(event):
	if !focused and $MarginContainer.visible:
		for x in [InputEventJoypadButton, InputEventJoypadMotion, InputEventKey]:
			if event is x:
				$PC.grab_focus()
				break
	else:
		for x in [1, 2, 3, 4]:
			if event.is_action("p" + str(x) + "_quit"):
				Global.splashed = false
# warning-ignore:return_value_discarded
				get_tree().change_scene("res://StartScreen.tscn")


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
	if focused:
		GameSound.play_sound("pluck_001")
	focused = true

func _on_PC_focus_entered():
	if focused:
		GameSound.play_sound("pluck_001")
	focused = true

func _on_Touch_focus_entered():
	if focused:
		GameSound.play_sound("pluck_001")
	focused = true
