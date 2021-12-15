extends AudioStreamPlayer


func play_sound(sound : String):
	stream = load("res://GUI/Audio/" + sound + ".wav")
	#play()
