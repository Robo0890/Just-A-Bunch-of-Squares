extends Panel

var player_id = 0

func _physics_process(delta):
	if visible:
		pass_input("jump", $Buttons/Right/Jump.pressed)
		pass_input("movement_left", $Buttons/Left/Left.pressed)
		pass_input("movement_right", $Buttons/Left/Right.pressed)
		pass_input("ready", $Buttons/Right/Ready.pressed)
		pass_input("flip", ($Buttons/Flip.is_hovered() and $Buttons/Right/Jump.pressed))

func pass_input(input_name, strength):
	if bool(strength):
		Input.action_press(("p" + str(player_id) + input_name), int(strength))
	else:
		Input.action_release("p" + str(player_id) + input_name)
