extends Label

var Level : Node
var Player : KinematicBody2D
var Game : Node2D

func _process(delta):
	Game = Level.Game
	match Level.game_state:
		"Lobby":
			$ProgressBar.visible = false
			if Player.ready:
				text = "        Ready"
				modulate = Color(1,1,1,1)
			else:
				text = "        Not Ready"
				modulate = Color(1,1,1,.5)
				
				$Sprite.modulate = Player.modulate
		"Playing":
			var display_type = str(Game.get_score(Player.player_id)).split("?=")[0]
			var display_value = str(Game.get_score(Player.player_id)).split("?=")[1]
			match display_type:
				"Text":
					if Player.active:
						modulate = Color(1,1,1,1)
						self_modulate = Color.green
					else:
						modulate = Color(1,1,1,.5)
						self_modulate = Color.red
					text = "        " + display_value
					$ProgressBar.visible = false
					
				"ProgressBar":
					if Player.active:
						modulate = Color(1,1,1,1)
						self_modulate = Color.white
					else:
						modulate = Color(1,1,1,.5)
						self_modulate = Color.red
					$ProgressBar.visible = true
					$ProgressBar.value = int(display_value)
					text = "        " + display_value
						
			

