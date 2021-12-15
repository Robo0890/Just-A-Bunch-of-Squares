extends Button

var Player : KinematicBody2D

func _ready():
	$Editor.hide()
	$Mask.modulate = Player.color
	$Editor/Color/Player/Mask.modulate = Player.color
	$Editor/Color/EditColor/HSlider.value = Player.color.h * 100
	

func _on_pressed():
	UIAudio.play_sound("Custom/select_001")
	$Editor.show()
	$Editor/Manage.show()
	$Editor/Manage/Color.modulate = Player.color
	$Editor/Manage/Done.grab_focus()



func _on_Done_pressed():
	UIAudio.play_sound("Custom/select_003")
	$Editor.hide()
	$Mask.modulate = Player.color
	$Editor/Color/Player/Mask.modulate = Player.color
	grab_focus()


func _on_Color_pressed():
	UIAudio.play_sound("Custom/select_003")
	$Editor/Manage.hide()
	$Editor/Color.show()
	$Editor/Color/EditColor/HSlider.grab_focus()



func _on_HSlider_value_changed(value):
	UIAudio.play_sound("Custom/click_001")
	Player.color = Color.from_hsv(value / 100, 1, 1)
	$Mask.modulate = Player.color
	$Editor/Color/Player/Mask.modulate = Player.color
	Profile.global_preserve[Player.player_id].color =  Player.color

func _on_Color_Done_pressed():
	UIAudio.play_sound("Custom/select_005")
	$Editor/Manage.show()
	$Editor/Color.hide()
	$Editor/Manage/Color.modulate = Player.color
	$Editor/Manage/Done.grab_focus()

func _process(delta):
	$Editor/Color/Player.texture = Player.skin_img
	$Icon.texture = Player.skin_img
	$Mask.texture = Player.skin_img_mask
	$Editor/Color/Player/Mask.texture = Player.skin_img_mask
	if Player.removing:
		queue_free()


func _on_Remove_pressed():
	UIAudio.play_sound("select_002")
	Player.remove()
