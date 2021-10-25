extends Panel


var Player : KinematicBody2D
var Level : Node

var data = {}
var ready = false

func _ready():
	$"MarginContainer/Info/Main Score".text = data.Main
	$Winner.visible = data.Winner
	$Particles/Gold.emitting = data.Winner
	
	for score in data.keys():
		if score != "Main" and score != "Winner":
			var label = $MarginContainer/Info/Subscore.duplicate()
			label.name = score
			label.text = score + ": " + str(data[score])
			$MarginContainer/Info.add_child(label)
	$MarginContainer/Info/Subscore.queue_free()
	$MarginContainer/Info.move_child($MarginContainer/Info/Bottom, $MarginContainer/Info.get_child_count())

	$MarginContainer/Info/PLayerImage.modulate = Player.modulate
	yield(get_tree().create_timer(1),"timeout")
	ready = true

func _process(delta):
	if ready:
		if Input.is_action_just_pressed("p" + str(Player.player_id) + "jump"):
			modulate = Color(1,1,1,.7)
			$Ok.disabled = true
			Level.ready_players.append(Player.player_id)
			InputMap.action_erase_events(("p" + str(Player.player_id) + "jump"))
