extends KinematicBody2D

onready var Level = get_parent().get_parent()

var player_id : int
var spawnpoint = Vector2(0,0)

var player_data = {
	"time" : 0
}

var speed = 2
var gravity = 39.29
var velocity = Vector2(0,0)
var jumpPower = 880
var max_jumps = 1

const DEFAULT_SPEED = 2
const DEFAULT_GRAVITY = 39.29
const DEFAULT_VELOCITY = Vector2(0,0)
const DEFAULT_JUMPPOWER = 880
const DEFAULT_MAX_JUMPS = 1

var falls = 0
var jump_count = 0
var active = false

var input_method = "Keyboard"
var is_respawning = false
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
		add_input_map(InputEventKey, "flip", KEY_SHIFT)
	if device_type == "Keyboard2":
		add_input_map(InputEventKey, "jump", KEY_UP)
		add_input_map(InputEventKey, "movement_left", KEY_LEFT)
		add_input_map(InputEventKey, "movement_right", KEY_RIGHT)
		add_input_map(InputEventKey, "ready", KEY_PERIOD)
		add_input_map(InputEventKey, "flip", KEY_BACKSLASH)

	if device_type == "Mobile":
		add_input_map(InputEventKey, "jump", KEY_PAGEDOWN)
		add_input_map(InputEventKey, "movement_left", KEY_PAGEDOWN)
		add_input_map(InputEventKey, "movement_right", KEY_PAGEDOWN)
		add_input_map(InputEventKey, "ready", KEY_PAGEDOWN)
		add_input_map(InputEventKey, "flip", KEY_PAGEDOWN)
	
	if device_type.split(":")[0] == "Gamepad":
		add_input_map(InputEventJoypadButton, "jump", JOY_XBOX_A)
		add_input_map(InputEventJoypadMotion, "movement_left", JOY_AXIS_0, -1.0)
		add_input_map(InputEventJoypadMotion, "movement_right", JOY_AXIS_0, 1.0)
		add_input_map(InputEventJoypadButton, "ready", JOY_XBOX_Y)
		add_input_map(InputEventJoypadButton, "flip", JOY_R2)
		
func _physics_process(delta):
	if $FloorDetector.is_colliding() and !is_respawning:
		if $FloorDetector.get_collider().name == "Course":
			spawnpoint = position
	
	
	if is_respawning:
		$Sprite.modulate = Color(1,1,1,.2)
		position.y += gravity
		if position.distance_to(spawnpoint) <= 20:
			$Sprite.modulate = Color.white
			is_respawning = false
			frozen = false
			$CollisionShape.disabled = false
	
	if active:
		player_data.time += .016
		
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
	if Input.is_action_just_pressed("p" + str(player_id) + "jump") and jumps != 0:
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
	
	if Input.is_action_just_pressed("p" + str(player_id) + "ready") and get_parent().get_parent().game_state == "Lobby":
		ready = !ready
	if Input.is_action_pressed("p" + str(player_id) + "flip") and is_on_ceiling():
		flip()
	
func kill(is_respwan, add_fall = false):
	if add_fall:
		falls += 1
	if is_respwan:
		respawn()
	else:
		active = false
		visible = false
		
func respawn():
	frozen = true
	$CollisionShape.disabled = true
	is_respawning = true
	position = spawnpoint + Vector2(0,-600)

func flip():
	$CollisionShape.disabled = true
	position.y -= 100
	if is_on_floor():
		flip()
	else:
		$CollisionShape.disabled = false
