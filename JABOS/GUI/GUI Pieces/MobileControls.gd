extends Control

var Level : Node

var player_id : int
# warning-ignore:unused_argument
func _ready():
	visible = false
	
func _process(delta):

	if visible:
		match Level.game_state:
			"Playing":
				$Panel/Right/Ready/Ready.visible = false
				$Panel/Left/Quit/Quit.visible = false
			"Lobby":
				$Panel/Right/Ready/Ready.visible = true
				$Panel/Left/Quit/Quit.visible = true
				$Panel2.visible = false
			"End":
				$Panel/Left/Left.visible = false
				$Panel/Left/Right/Right.visible = false
				$Panel.self_modulate = Color(1,1,1,0)
				$Panel2.visible = true
				


func _on_Left_pressed():
	Input.action_press("p" + str(player_id) + "movement_left", 1)
func _on_Left_released():
	Input.action_release("p" + str(player_id) + "movement_left")

func _on_Right_pressed():
	Input.action_press("p" + str(player_id) + "movement_right", 1)
func _on_Right_released():
	Input.action_release("p" + str(player_id) + "movement_right")

func _on_Jump_pressed():
	Input.action_press("p" + str(player_id) + "jump", 1)
	$Panel/Right/Jump/Jump/Flip.visible = true
func _on_Jump_released():
	$Panel/Right/Jump/Jump/Flip.visible = false
	Input.action_release("p" + str(player_id) + "jump")

func _on_Ready_pressed():
	Input.action_press("p" + str(player_id) + "ready", 1)
func _on_Ready_released():
	Input.action_release("p" + str(player_id) + "ready")

"""func _on_Quit_pressed():
	Input.action_press("p4_quit",1)
func _on_Quit_released():
	Input.action_release("p4_quit")"""

func _on_Flip_pressed():
	Input.action_press("p" + str(player_id) + "flip",1)
func _on_Flip_released():
	Input.action_release("p" + str(player_id) + "flip")
