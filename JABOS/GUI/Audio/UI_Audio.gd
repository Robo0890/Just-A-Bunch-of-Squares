extends AudioStreamPlayer

var sxf = false

func play_sound(sound : String):
	stream = load("res://GUI/Audio/" + sound + ".wav")
	play()
	if !sxf:
		stream = null

func play_rand(soundname : String, start : int, distance : int):
	var sound = soundname + str(int(rand_range(start, distance)))
	stream = load("res://GUI/Audio/" + sound + ".wav")
	play()
