extends Node2D


onready var Part = preload("res://Gamemodes/Classic/Parts.tscn")

var gamemode = "Default"

var random_part = 1
var max_parts = 1

func _ready():
	var c = Part.instance()
	max_parts = c.get_child_count()
	c.queue_free()

func _physics_process(delta):
	position = get_parent().Level.Game_Camera.transform.origin
	$Course.position = Vector2(300,400) - position
	
	
	
func load_part(part):
	print("loaded part " + str(part))
	var p = Part.instance()
	var boxes = p.get_node("Part" + str(part)).get_children()
	for x in boxes:
		x.get_parent().remove_child(x)
		x.position.x += position.x + 1500
		$Course.call_deferred("add_child", x)
	p.queue_free()
	

func _on_Area2D_area_exited(body : Object):
	if body.is_in_group("End"):
		random_part = int(rand_range(1,max_parts))
		body.queue_free()
		load_part(random_part)
		
