@tool
@icon("res://Images/Icons/customicons/x2/Player.png")
extends Node
class_name Sqaure

@onready var base : Sprite2D
@onready var mask : Sprite2D

@export var color : Color = Color.WHITE:
	set(c):
		color = c
		mask.modulate = color
		
@export var skin : Texture2D = load("res://Skins/Default/Default.png"):
	set(s):
		skin = s
		base.texture = skin
		mask.texture = skin

func _init():
	base = Sprite2D.new()
	mask = Sprite2D.new()
	
	base.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	base.region_enabled = true
	base.region_rect = Rect2(Vector2.ZERO, Vector2(32,32))
	
	mask.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	mask.region_enabled = true
	mask.region_rect = Rect2(Vector2(0, 32), Vector2(32,32))
	
	add_child(base)
	add_child(mask)
