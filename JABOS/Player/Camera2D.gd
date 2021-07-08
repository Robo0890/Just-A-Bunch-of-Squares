extends Camera2D



# warning-ignore:unused_argument
func _physics_process(delta):
	if get_parent().start and get_parent().players != 0:
		var move = 0
		for x in get_tree().get_nodes_in_group("Player"):
			move += x.position.x - position.x
		move = ((move / get_parent().players) / 100) + 8
		position.x += (move/2) + (.0001 * position.x)
		zoom = lerp(zoom, Vector2(1,1),.1)
		$Control.rect_size = Vector2(1024,600)
	else:
		position = lerp(position,Vector2(0,0),.1)
		zoom = lerp(zoom, Vector2(.5,.5),.1)
		$Control.rect_size = Vector2(512,300)
	$Control.rect_position = -$Control.rect_size/2
	$Control/GuiHandler.rect_scale = zoom
	$MobileControls.rect_scale = zoom

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and get_parent().start:
		var player = body.player
		get_parent().players -= 1
		get_parent().alive_players.erase(player)
		get_parent().player_scores[player].jumps = body.total_jumps
		get_parent().player_scores[player].falls = body.falls
		body.queue_free()
		if get_parent().players == 0:
			get_parent().player_scores[player].win = true
			get_parent().start = false
# warning-ignore:return_value_discarded
			end_game()
			

func end_game():
	GameSound.play_sound("minimize_008")
	get_parent().start = false
	$Control/GuiHandler/Panel/Label.text = "  Press        to Continue"
	match Global.device:
		"mobile":
			$Control/GuiHandler/Panel/Label/Sprite.texture = load("res://GUI/Icons/up.png")
		"gamepad":
			$Control/GuiHandler/Panel/Label/Sprite.texture = load("res://GUI/Icons/buttonA.png")
		"pc":
			$Control/GuiHandler/Panel/Label/Sprite.texture = load("res://GUI/Icons/button1.png")
	$Control/GuiHandler/Panel/Label.visible = true
	$Control/GuiHandler/MarginContainer/VBoxContainer.visible = false
	$Control/GuiHandler/Panel.rect_size.y = 0
	$Control/GuiHandler.end = true
	yield(get_tree().create_timer(1),"timeout")
	$Control/GuiHandler.allow_continue = true

func reset():
	get_tree().change_scene("res://Level.tscn")
