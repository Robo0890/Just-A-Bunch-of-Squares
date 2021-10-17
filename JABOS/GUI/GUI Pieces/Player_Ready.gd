extends Label


var player : KinematicBody2D

func _process(delta):
	if player.ready:
		text = "        Ready"
		modulate = Color(1,1,1,1)
	else:
		text = "        Not Ready"
		modulate = Color(1,1,1,.5)
		
		$Sprite.modulate = player.modulate
