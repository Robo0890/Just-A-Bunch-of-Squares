extends Control

var Level : Node
var Player : KinematicBody2D
var Game : Node2D

func _process(delta):
	Game = Level.Game
	
	$Sprite.texture = load("res://Images/Skins/" + Player.skin + ".png")
	$SpriteMask.texture = load("res://Images/Skins/mask." + Player.skin + ".png")
	
	$SpriteMask.modulate = Player.color
	match Level.game_state:
		"Lobby":
			$ProgressBar.visible = false
			if Player.ready:
				$Text.text = "        Ready"
				$Text.modulate = Color(1,1,1,1)
			else:
				$Text.text = "        Not Ready"
				$Text.modulate = Color(1,1,1,.5)
				
		"Playing":
			var display_type = str(Game.get_display_score(Player.player_id)).split("?=")[0]
			var display_value = str(Game.get_display_score(Player.player_id)).split("?=")[1]
			var pram2 = str(Game.get_display_score(Player.player_id)).split("?=")[2]
			match display_type:
				"Text":
					display_value = str(Game.get_display_score(Player.player_id)).split("?=")[1]
					if Player.active:
						$Text.modulate = Color.green
					else:
						$Text.modulate = Color.red
					$Text.text = "        " + display_value
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
					$Text.text = "        " + str(display_value) + "/" + str(pram2)
						
			

