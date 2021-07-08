extends Control

# warning-ignore:unused_argument
func _process(delta):
	if get_parent().get_parent().start:
		$Ready.visible = false
		$Quit.visible = false
	else:
		$Ready.visible = get_parent().get_parent().active_players.has(4)
		$Quit.visible = get_parent().get_parent().active_players.has(4)
	if Global.device == "mobile":
		$Panel2/Quit2.visible = false
		$Panel2.visible = true
		$Panel.visible = false
		$Right.visible = false
		$Left.visible = false
		$Jump.visible = true
		$Ready.visible = false
		$Panel2.visible = !get_parent().get_parent().active_players.has(4)
		$Panel.visible = get_parent().get_parent().active_players.has(4)
		$Right.visible = get_parent().get_parent().active_players.has(4)
		$Left.visible = get_parent().get_parent().active_players.has(4)
	else:
		$Panel2/Quit2.visible = true
		$Panel2.visible = true
		$Panel.visible = false
		$Right.visible = false
		$Left.visible = false
		$Jump.visible = false
		$Ready.visible = false
		$Quit.visible = false


func _on_Left_pressed():
	Input.action_press("p4_movement_left", 1)
func _on_Left_released():
	Input.action_release("p4_movement_left")

func _on_Right_pressed():
	Input.action_press("p4_movement_right", 1)
func _on_Right_released():
	Input.action_release("p4_movement_right")

func _on_Jump_pressed():
	Input.action_press("p4_movement_jump", 1)
func _on_Jump_released():
	Input.action_release("p4_movement_jump")

func _on_Ready_pressed():
	Input.action_press("p4_ready", 1)
func _on_Ready_released():
	Input.action_release("p4_ready")

func _on_Quit_pressed():
	Input.action_press("p4_quit",1)
func _on_Quit_released():
	Input.action_release("p4_quit")



func _on_Quit2_pressed():
# warning-ignore:return_value_discarded
	Global.players_active = []
	get_tree().change_scene("res://StartScreen.tscn")
