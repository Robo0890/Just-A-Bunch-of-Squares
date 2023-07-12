extends CharacterBody2D
class_name Player

@onready var square = preload("res://Classes/Square.tscn").instantiate()

func _ready():
	add_child(square)
