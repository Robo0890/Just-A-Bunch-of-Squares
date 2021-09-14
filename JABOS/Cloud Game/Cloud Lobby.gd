extends Control


onready var key = preload("res://GUI/Key.tscn")

var keyboard = "1234567890qwertyuiopasdfghjklzxcvbnm"

func _ready():
	
	for x in keyboard.length():
		x = keyboard[x]
		var k = key.instance()
		k.name = "Key_" + x
		k.text = str(x).capitalize()
		$Keyboard/Board.add_child(k)
		k.connect("pressed", self, "key_pressed")
	$Keyboard/Board.move_child($"Keyboard/Board/Backspace_<",keyboard.length() + 1)
	$Keyboard/Board.move_child($"Keyboard/Board/Confirm_=",10)
func _process(delta):
	for x in $Keyboard/Board.get_children():
		if x.pressed:
			var key_pressed = str(x.name).split("_")[1]
			print(key_pressed)



