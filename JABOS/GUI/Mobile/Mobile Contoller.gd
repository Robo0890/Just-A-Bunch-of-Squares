extends Panel

var player_id = 0

func _physics_process(delta):
	pass



func _on_Jump_button_down():
	Input.action_press(("p" + str(player_id) + "jump"), 1)
func _on_Jump_button_up():
	Input.action_release("p" + str(player_id) + "jump")
	
func _on_Left_button_down():
	Input.action_press(("p" + str(player_id) + "movement_left"), 1)
func _on_Left_button_up():
	Input.action_release("p" + str(player_id) + "movement_left")

func _on_Right_button_down():
	Input.action_press(("p" + str(player_id) + "movement_right"), 1)
func _on_Right_button_up():
	Input.action_release("p" + str(player_id) + "movement_right")
	
func _on_Ready_button_down():
	Input.action_press(("p" + str(player_id) + "ready"), 1)
func _on_Ready_button_up():
	Input.action_release("p" + str(player_id) + "ready")

func _on_Flip_mouse_entered():
	Input.action_press(("p" + str(player_id) + "flip"), 1)
func _on_Flip_mouse_exited():
	Input.action_release("p" + str(player_id) + "flip")
