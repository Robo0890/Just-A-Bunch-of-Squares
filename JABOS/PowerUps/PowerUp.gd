extends Node2D

signal collected

export var powerup_name = "none"
export var effect = "none"
export var time = 0

var powerup_data = {
	
}

func _ready():
	powerup_data = {
		"name" : powerup_name,
		"effect" : effect,
		"time" : time,
		"timeout" : time
	}

func _on_CollectArea_body_entered(body):
	if body.is_in_group("Player"):
		body.powerup = powerup_data
		emit_signal("collected")
		queue_free()
