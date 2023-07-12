@tool
extends Node
class_name Sqaure

@export var color : Color = Color.WHITE:
	set(c):
		color = c
		$Color.modulate = color
		
@export var skin : Texture2D = load("res://Skins/Default/Default.png"):
	set(s):
		skin = s
		$Color.texture = skin
		$Sprite.texture = skin

