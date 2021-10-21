extends Panel


var Player : KinematicBody2D
var Level : Node

var data = {}

func _ready():
	$"MarginContainer/Info/Main Score".text = data.Main
	$Winner.visible = data.Winner
	
	for score in data.keys():
		if score != "Main" and score != "Winner":
			var label = $MarginContainer/Info/Subscore.duplicate()
			label.name = score
			label.text = score + ": " + str(data[score])
			print(score)
			$MarginContainer/Info.add_child(label)
	$MarginContainer/Info/Subscore.queue_free()
	$MarginContainer/Info.move_child($MarginContainer/Info/Bottom, $MarginContainer/Info.get_child_count())

	$MarginContainer/Info/PLayerImage.modulate = Player.modulate
