extends Control

var splash = false

func _ready():
	$Update.hide()
	get_tree().debug_collisions_hint = true
	
	var load_data = Save.load_data("jabos_profile")
	if load_data.size() > 0:
		#print(load_data)
		for x in load_data:
			Profile.data[x] = load_data[x]
	else:
		Profile.clear()

	OS.set_window_title("Just A Bunch of Squares")
	
	var giftcode = JavaScript.eval("""
		var url_string = window.location.href;
		var url = new URL(url_string);
		url.searchParams.get("gift");""")
		
	if giftcode != null:
		Profile.gift_link = str(giftcode)
	
	if splash:
		$Background/AnimationPlayer.play("EonSplash")
		yield(get_tree().create_timer(1),"timeout")
		$GameSound.play()
	else:
		_on_AnimationPlayer_animation_finished("EonSplash")

# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "EonSplash":
		
		if Profile.data.version < Profile.CURRENT_VERSION:
			$Update.show()
			yield($Update/MarginContainer/VBoxContainer/HSplitContainer/TLDR/Button, "pressed")
			$Update.hide()
	Profile.data.version = Profile.CURRENT_VERSION
	get_tree().change_scene("res://Worlds/Level.tscn")


func _on_TouchScreenButton_pressed():
	get_tree().change_scene("res://Worlds/Level.tscn")
