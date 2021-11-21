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

var color = Color.white
var skin = "Default"
var skin_id = 0

var input_method = "Keyboard"
var is_respawning = false
var frozen = false
var device_type = "Cloud"
var ready = false
var jumps = 1

var in_wardrode = false

#Skins
const SKIN_DEFAULT = 0
const SKIN_ROBOT = 1




func _ready():
	change_skin(SKIN_DEFAULT)
	
	color = Color.from_hsv(.4 * (player_id), 1, 1)
	if device_type == "Keyboard1":
		add_input_map(InputEventKey, "jump", KEY_W)
		add_input_map(InputEventKey, "movement_left", KEY_A)
		add_input_map(InputEventKey, "movement_right", KEY_D)
		add_input_map(InputEventKey, "ready", KEY_R)
		add_input_map(InputEventKey, "flip", KEY_SHIFT)
		add_input_map(InputEventKey, "ability", KEY_E)
	if device_type == "Keyboard2":
		add_input_map(InputEventKey, "jump", KEY_UP)
		add_input_map(InputEventKey, "movement_left", KEY_LEFT)
		add_input_map(InputEventKey, "movement_right", KEY_RIGHT)
		add_input_map(InputEventKey, "ready", KEY_COMMA)
		add_input_map(InputEventKey, "flip", KEY_PERIOD)
		add_input_map(InputEventKey, "ability", KEY_M)

	if device_type == "Mobile":
		add_input_map(InputEventKey, "jump", KEY_PAGEDOWN)
		add_input_map(InputEventKey, "movement_left", KEY_PAGEDOWN)
		add_input_map(InputEventKey, "movement_right", KEY_PAGEDOWN)
		add_input_map(InputEventKey, "ready", KEY_PAGEDOWN)
		add_input_map(InputEventKey, "flip", KEY_PAGEDOWN)
		add_input_map(InputEventKey, "ability", KEY_PAGEDOWN)
	
	if device_type.split(":")[0] == "Gamepad":
		add_input_map(InputEventJoypadButton, "jump", JOY_XBOX_A)
		add_input_map(InputEventJoypadMotion, "movement_left", JOY_AXIS_0, -1.0)
		add_input_map(InputEventJoypadMotion, "movement_right", JOY_AXIS_0, 1.0)
		add_input_map(InputEventJoypadButton, "ready", JOY_XBOX_Y)
		add_input_map(InputEventJoypadButton, "flip", JOY_R2)
		add_input_map(InputEventJoypadButton, "ability", JOY_XBOX_X)
		
func _physics_process(delta):
	
	$SpriteMask.modulate = color
	
	
	
	
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
	
	
	$Wardrobe.visible = in_wardrode
	
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
	if !in_wardrode:
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
			
			
		if Input.is_action_just_pressed("p" + str(player_id) + "ability"):
			match Level.game_state:
				"Lobby":
					in_wardrode = true
	else:
		velocity.x = 0
		velocity.y += gravity
		
		if !skin_id >= Profile.data.Owned.Skins.size() and !skin_id < 0:
			skin = Profile.data.Owned.Skins[skin_id]
			$Wardrobe/CenterContainer/HBoxContainer/Skin.texture_normal = load("res://Images/Skins/" + skin + ".png")
		else:
			skin_id = 0
			skin = Profile.data.Owned.Skins[skin_id]
			$Wardrobe/CenterContainer/HBoxContainer/Skin.texture_normal = load("res://Images/Skins/" + skin + ".png")
			
		if Input.is_action_just_pressed("p" + str(player_id) + "movement_right"):
			skin_id += 1
		if Input.is_action_just_pressed("p" + str(player_id) + "movement_left"):
			skin_id -= 1
			
		if Input.is_action_just_pressed("p" + str(player_id) + "ability"):
			in_wardrode = false
			change_skin(skin_id)
		
		
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
		
func change_skin(skin_id : int):
	var skin_name = Profile.data.Owned.Skins[skin_id]
	skin = skin_name
	$Sprite.texture = load("res://Images/Skins/" + skin_name + ".png")
	$SpriteMask.texture = load("res://Images/Skins/mask." + skin_name + ".png")


func _on_Left_pressed():
	skin_id -= 1


func _on_Right_pressed():
	skin_id += 1


func _on_Skin_pressed():
	in_wardrode = false
	change_skin(skin_id)
