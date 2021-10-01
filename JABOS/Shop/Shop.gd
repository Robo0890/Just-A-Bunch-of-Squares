extends Control


onready var Level = get_parent().get_parent()
onready var GUI = Level.GUI


func _ready():
	load_until(get_tree().create_timer(3), "timeout")
	$Head/HBoxContainer/Rubies.text = str(Profile.data.ruby)
	$Head/HBoxContainer/Profile/HBoxContainer/ProgressBar/Level/Label.text = "Level " + str(Profile.data.level)
	$Head/HBoxContainer/Profile/HBoxContainer/ProgressBar.max_value = Profile.xp_for_next_level()
	$Head/HBoxContainer/Profile/HBoxContainer/ProgressBar.value = Profile.data.xp
	$Head/HBoxContainer/Profile/HBoxContainer/ProgressBar/Level/XP.text = "XP " + str(Profile.data.xp) + "/" + str(Profile.xp_for_next_level())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_pressed():
	GUI.is_shop_visible = false
	GUI.show()
	GUI.GamemodeBox.select(0)
	queue_free()

func load_until(object, stop_signal : String):
	var visible_objects = []
	for x in get_children():
		if x.visible:
			visible_objects.append(x)
			x.hide()
	$Loading.show()
	yield(object, stop_signal)
	$Loading.hide()
	for x in visible_objects:
		x.show()
