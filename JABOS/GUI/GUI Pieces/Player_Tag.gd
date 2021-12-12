extends Control

var Level : Node
var Player : KinematicBody2D
var Game : Node2D

func _process(delta):
	if Player.removing:
		queue_free()
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
			
			if Player.active:
				modulate = Color(1,1,1,1)
			else:
				modulate = Color(1,1,1,.5)
			
			var display_data = str(Game.get_display_score(Player.player_id)).split("?=")
			var display_type = display_data[0]
			var display_prams = display_data
			
			match display_type:
				"Text":
					var display_value = str(display_prams[1])
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
					$ProgressBar.value = int(display_prams[1])
					$ProgressBar.max_value = int(display_prams[2])
					$Text.text = "        " + str(display_prams[1]) + "/" + str(display_prams[2])
					
				"Bool":
					if bool(int(display_prams[1])):
						$Text.text = "        " + str(display_prams[2])
						modulate = Color(1,1,1,1)
					else:
						modulate = Color(1,1,1,.5)
						$Text.text = "        " + str(display_prams[3])
				
				"List":
					if bool(int(display_prams[1])):
						$Text.text = "        " + display_prams[2]
						modulate = Color(1,1,1,1)
					else:
						modulate = Color(1,1,1,.5)
						$Text.text = "        " + display_prams[2]
					
					if !Player.active:
						modulate = Color(1,1,1,.5)
						self_modulate = Color.red
						$Text.text = "        " + "Out"
			

