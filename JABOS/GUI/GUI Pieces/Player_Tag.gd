extends Label

var Level : Node
var Player : KinematicBody2D
var Game : Node2D

func _process(delta):
	match Level.game_state:
		"Lobby":
			if Player.ready:
				text = "        Ready"
				modulate = Color(1,1,1,1)
			else:
				text = "        Not Ready"
				modulate = Color(1,1,1,.5)
				
				$Sprite.modulate = Player.modulate
		"Playing":
			if Player.active:
				modulate = Color(1,1,1,1)
				self_modulate = Color.green
				text = "        " + str(Game.get_score(Player.player_id))
			else:
				modulate = Color(1,1,1,.5)
				self_modulate = Color.red


