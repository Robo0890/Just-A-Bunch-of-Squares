extends Button

var Player : KinematicBody2D

func _ready():
	$Editor.hide()
	$Mask.modulate = Player.color
	$Editor/Color/Player/Mask.modulate = Player.color
	$Editor/Color/EditColor/HSlider.value = Player.color.h * 100
	

func _on_pressed():
	$Editor.show()
	$Editor/Manage.show()
	$Editor/Manage/Color.modulate = Player.color



func _on_Done_pressed():
	$Editor.hide()
	$Mask.modulate = Player.color
	$Editor/Color/Player/Mask.modulate = Player.color


func _on_Color_pressed():
	$Editor/Manage.hide()
	$Editor/Color.show()
	



func _on_HSlider_value_changed(value):
	Player.color = Color.from_hsv(value / 100, 1, 1)
	$Mask.modulate = Player.color
	$Editor/Color/Player/Mask.modulate = Player.color
	Profile.global_preserve[Player.player_id].color =  Player.color

func _on_Color_Done_pressed():
	$Editor/Manage.show()
	$Editor/Color.hide()
	$Editor/Manage/Color.modulate = Player.color

func _process(delta):
	$Editor/Color/Player.texture = Player.skin_img
	$Icon.texture = Player.skin_img
	$Mask.texture = Player.skin_img_mask
	$Editor/Color/Player/Mask.texture = Player.skin_img_mask
	if Player.removing:
		queue_free()


func _on_Remove_pressed():
	Player.remove()
