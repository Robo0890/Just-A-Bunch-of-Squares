extends Control

var splash = false

func _ready():
	if splash:
		$Background/AnimationPlayer.play("EonSplash")
		yield(get_tree().create_timer(.3),"timeout")
		$GameSound.play()
	else:
		_on_AnimationPlayer_animation_finished("EonSplash")

# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "EonSplash":
		get_tree().change_scene("res://Worlds/Level.tscn")


func _on_TouchScreenButton_pressed():
	get_tree().change_scene("res://Worlds/Level.tscn")