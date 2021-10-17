extends KinematicBody2D


var player_id : int
var spawnpoint = Vector2(0,0)

var speed = 2
var gravity = 39.29
var velocity = Vector2(0,0)
var jumpPower = 880
var max_jumps = 1

var falls = 0
var jump_count = 0
var active = false
var time = 0

var frozen = false

var device_type = "Cloud"

var ready = false

var jumps = 1

func _ready():
	modulate = Color.from_hsv(.4 * (player_id), 1, 1)
	if device_type == "Keyboard1":
		add_input_map(InputEventKey, "jump", KEY_W)
		add_input_map(InputEventKey, "movement_left", KEY_A)
		add_input_map(InputEventKey, "movement_right", KEY_D)
		add_input_map(InputEventKey, "ready", KEY_R)
	if device_type == "Keyboard2":
		add_input_map(InputEventKey, "jump", KEY_UP)
		add_input_map(InputEventKey, "movement_left", KEY_LEFT)
		add_input_map(InputEventKey, "movement_right", KEY_RIGHT)
		add_input_map(InputEventKey, "ready", KEY_END)
	
	if device_type.split(":")[0] == "Gamepad":
		add_input_map(InputEventJoypadButton, "jump", JOY_XBOX_A)
		add_input_map(InputEventJoypadMotion, "movement_left", JOY_AXIS_0, -1.0)
		add_input_map(InputEventJoypadMotion, "movement_right", JOY_AXIS_0, 1.0)
		add_input_map(InputEventJoypadButton, "ready", JOY_XBOX_Y)
		
func _physics_process(delta):
	
	if active:
		time += .016
		
	process_input()
	if !frozen:
		move_and_slide(velocity, Vector2.UP)


func add_input_map(input_type, input_name, input_scancode, extra_info = 0):
	var ev : InputEvent
	match input_type:
		InputEventJoypadButton:
			ev = InputEventJoypadButton.new()
			ev.button_index = input_scancode
			ev.device = int(device_type.split(":")[1])
		InputEventJoypadMotion:
			ev = InputEventJoypadMotion.new()
			ev.axis = input_scancode
			ev.axis_value = extra_info
			ev.device = int(device_type.split(":")[1])
		InputEventKey:
			ev = InputEventKey.new()
			ev.scancode = input_scancode
	
	InputMap.add_action("p" + str(player_id) + input_name)
	InputMap.action_add_event("p" + str(player_id) + input_name, ev)

func jump():
	velocity.y = -jumpPower
	if active:
		jump_count += 1

func process_input():
	if Input.is_action_pressed("p" + str(player_id) + "jump") and jumps != 0:
		jump()
		jumps -= 1
	elif !is_on_floor():
		velocity.y += gravity
	else:
		velocity.y = 0
		jumps = max_jumps
	
	if Input.is_action_pressed("p" + str(player_id) + "jump") and is_on_ceiling():
		velocity.y = -10
		
	if Input.is_action_just_pressed("p" + str(player_id) + "jump") and is_on_wall():
		jump()
		jumps = max_jumps
		
	velocity.x = (speed * 500) * (Input.get_action_strength("p" + str(player_id) + "movement_right") - Input.get_action_strength("p" + str(player_id) + "movement_left"))
	
	if Input.is_action_just_pressed("p" + str(player_id) + "ready"):
		ready = !ready

func kill(is_respwan):
	falls += 1
	if is_respwan:
		position = spawnpoint
	else:
		active = false
		visible = false
		

