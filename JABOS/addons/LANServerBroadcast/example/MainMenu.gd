extends VBoxContainer

func _on_HostButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://example/HostGame.tscn")

func _on_BrowseButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://example/ServerBrowser.tscn")
