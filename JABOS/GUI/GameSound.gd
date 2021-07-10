extends AudioStreamPlayer

func play_sound(sound : String):
	stream = load("res://addons/kenney_ui_audio/" + sound + ".wav")
	play()
