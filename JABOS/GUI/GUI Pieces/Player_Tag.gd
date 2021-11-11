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
			var display_type = str(Game.get_display_score(Player.player_id)).split("?=")[0]
			var display_value = str(Game.get_display_score(Player.player_id)).split("?=")[1]
			var pram2 = str(Game.get_display_score(Player.player_id)).split("?=")[2]
			match display_type:
				"Text":
					display_value = str(Game.get_display_score(Player.player_id)).split("?=")[1]
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
					$ProgressBar.max_value = int(pram2)
					text = "        " + str(display_value) + "/" + str(pram2)
						
			

