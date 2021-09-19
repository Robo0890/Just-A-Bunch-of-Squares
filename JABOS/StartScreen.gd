extends Control

func _ready():
	#Checks if a join code is present 
	#and sets the according Global variable as so
	var joincode = JavaScript.eval("""
		var url_string = window.location.href;
		var url = new URL(url_string);
		url.searchParams.get("join");""")
	if joincode != null:
		Global.cloudcode = joincode

#Changes scene
func _on_VideoPlayer_finished():
	get_tree().change_scene("res://GUI/GameMode.tscn")
