extends Position2D


func _ready():
	randomize()
	if Profile.enabled_powerups.size() == 0:
		queue_free()
		return
	$Sprite.queue_free()
	var rand_item = int(round(rand_range(0, Profile.enabled_powerups.size() - 1)))
	var powerup = Profile.enabled_powerups[rand_item]

	
	var p = load("res://PowerUps/" + powerup + ".tscn").instance()
	p.connect("collected", self, "queue_free")
	add_child(p)
