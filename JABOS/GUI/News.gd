extends Control

func _ready():
	visible = true
	if Global.is_up_to_date():
		queue_free()

func _on_Button_pressed():
	queue_free()
