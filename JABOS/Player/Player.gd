extends KinematicBody2D

signal player_collision
signal killed

onready var Level = get_parent().get_parent()

var player_id : int
var spawnpoint = Vector2(0,0)

var player_data = {
	"time" : 0
}

var selected = false

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
var skin_img = load("res://Images/Face.png")
var skin_img_mask = load("res://Images/Face.png")

var input_method = "Keyboard"
var is_respawning = false
var frozen = false
var device_type = "Cloud"
var ready = false
var jumps = 1

var removing = false

var in_wardrode = false

#Skins
var glowing_skins = ["Robot", "Cyborg", "CyberDog"]

#Power ups
var powerup = {
	"name" : "none",
	"effect" : "none",
	"time" : 0,
	"timeout" : 0
}

const CLEAR_POWERUP = {
	"name" : "none",
	"effect" : "none",
	"time" : 0,
	"timeout" : 0
}




func _ready():
	
	for effect in get_tree().get_nodes_in_group("powerup_effect"):
		if effect.get_parent().get_parent() == self:
			effect.emitting = false
			effect.visible = true
	
	
	change_skin(0)
	if color == Color.white:
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
	
	#*****POWER UPS*****
	
	if powerup.name != "none":
	
		if powerup.timeout != -1:
			powerup.timeout -= 1.0 * delta
			if powerup.timeout <= 0:
				powerup = CLEAR_POWERUP
		
		if powerup.time == -1:
			$PowerUpTime.hide()
			$PowerUpUse.show()
		else:
			$PowerUpTime.show()
			$PowerUpUse.hide()
			$PowerUpTime.visible = !powerup.name == "none"
			$PowerUpTime.max_value = powerup.time
			$PowerUpTime.value = powerup.timeout
			$PowerUpTime.step = powerup.time / 100
	else:
		$PowerUpTime.hide()
		$PowerUpUse.hide()
	
	
	$Effects_Modulate.modulate = color
	
	for effect in get_tree().get_nodes_in_group("powerup_effect"):
		if effect.get_parent().get_parent() == self:
			effect.emitting = false
		
	for effect in get_tree().get_nodes_in_group(powerup.effect):
		if effect.get_parent().get_parent() == self:
			effect.emitting = true
			
	

	
	#*****POWER UPS*****
	
	if !removing:
		$Selected.visible = selected
		$TouchArea.modulate.a = .8 * int(selected)
		
		

		
		if !device_type.split(":")[0] == "Cloud":
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
				player_data.time += 1.0 * delta
			
			
			
			
			
			$Wardrobe.visible = in_wardrode
			
			if Level.GUI.ui_focus == "none":
				process_input()
			if !frozen:
				move_and_slide(velocity, Vector2.UP)
				modulate = Color(1, 1, 1, 1)
			else:
				modulate = Color(1, 1, 1, .5)
		else:
			position.x = Level.Cloud.players[device_type.split(":")[1]].xpos

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
			if $CeilingDetector.is_colliding():
				if $CeilingDetector.get_collider().is_in_group("Player"):
					pass
			velocity.y = -10
			
		if Input.is_action_just_pressed("p" + str(player_id) + "jump") and is_on_wall():
			jump()
			jumps = max_jumps
			
			
		#****X VELOCITY*****
		velocity.x = ((speed * 500) * (Input.get_action_strength("p" + str(player_id) + "movement_right") - Input.get_action_strength("p" + str(player_id) + "movement_left")))
		#*******************
		
		if Input.is_action_just_pressed("p" + str(player_id) + "ready") and get_parent().get_parent().game_state == "Lobby":
			ready = !ready
			$SoundBox.play_sound("drop_001")
		if Input.is_action_pressed("p" + str(player_id) + "flip"):
			if is_on_ceiling():
				if $CeilingDetector.is_colliding():
					if !$CeilingDetector.get_collider().is_in_group("Player"):
						flip()
				else:
					flip()
				
					
			elif !is_on_floor():
				velocity.x *= 2
			
			
		if Input.is_action_just_pressed("p" + str(player_id) + "ability"):
			match Level.game_state:
				"Lobby":
					in_wardrode = true
					$SoundBox.play_sound("Custom/select_001")
				"Playing":
					if active:
						use_powerup()
	else:
		velocity.x = 0
		velocity.y += gravity
		
		if !skin_id >= Profile.data.Owned.Skins.size() and !skin_id < 0:
			skin = Profile.data.Owned.Skins[skin_id]
			$Wardrobe/CenterContainer/HBoxContainer/Skin.texture_normal = load("res://Images/Skins/" + skin + ".png")
			$Wardrobe/Nametag/Name.text = skin
		else:
			if skin_id >= Profile.data.Owned.Skins.size():
				skin_id = 0
			if skin_id < 0:
				skin_id = Profile.data.Owned.Skins.size() - 1
			skin = Profile.data.Owned.Skins[skin_id]
			$Wardrobe/Nametag/Name.text = skin
			$Wardrobe/CenterContainer/HBoxContainer/Skin.texture_normal = load("res://Images/Skins/" + skin + ".png")
			
		if Input.is_action_just_pressed("p" + str(player_id) + "movement_right"):
			skin_id += 1
			$SoundBox.play_sound("Custom/select_003")
		if Input.is_action_just_pressed("p" + str(player_id) + "movement_left"):
			skin_id -= 1
			$SoundBox.play_sound("Custom/select_003")
			
		if Input.is_action_just_pressed("p" + str(player_id) + "ability"):
			in_wardrode = false
			change_skin(skin_id)
			$SoundBox.play_sound("Custom/select_005")
		
		
func kill(is_respwan, add_fall = false):
	if add_fall:
		falls += 1
	if is_respwan:
		respawn()
	else:
		$CollisionShape.disabled = true
		active = false
		visible = false
		position.x = -2048
		frozen = true
		emit_signal("killed", self)
	
		
func respawn():
	frozen = true
	$CollisionShape.call_deferred("hide")
	is_respawning = true
	position = spawnpoint + Vector2(0,-600)

func flip():
	$CollisionShape.disabled = true
	position.y -= 100
	if is_on_floor():
		flip()
	else:
		$CollisionShape.disabled = false
		
# warning-ignore:shadowed_variable
func change_skin(id : int):
	skin_id = id
	var skin_name = Profile.data.Owned.Skins[skin_id]
	skin = skin_name
	$Sprite.texture = load("res://Images/Skins/" + skin_name + ".png")
	$SpriteMask.texture = load("res://Images/Skins/mask." + skin_name + ".png")
	skin_img = load("res://Images/Skins/" + skin_name + ".png")
	skin_img_mask = load("res://Images/Skins/mask." + skin_name + ".png")
	
	if glowing_skins.has(skin_name):
		$SpriteMask/Glow.visible = true
	else:
		$SpriteMask/Glow.visible = false
		
	Profile.global_preserve[player_id].skin = skin_id

func _on_Left_pressed():
	skin_id -= 1


func _on_Right_pressed():
	skin_id += 1


func _on_Skin_pressed():
	in_wardrode = false
	change_skin(skin_id)
	
func remove():
	removing = true
	visible = false
	Profile.global_preserve.erase(player_id)
	Level.ready_players.erase(player_id)
	Level.Manager.active_players.erase(player_id)
	Level.Manager.connected_devices.erase(device_type)
	Level.Manager.next_player_id = player_id
	InputMap.erase_action("p" + str(player_id) + "jump")
	InputMap.erase_action("p" + str(player_id) + "ready")
	InputMap.erase_action("p" + str(player_id) + "movement_left")
	InputMap.erase_action("p" + str(player_id) + "movement_right")
	InputMap.erase_action("p" + str(player_id) + "flip")
	InputMap.erase_action("p" + str(player_id) + "ability")
	yield(get_tree().create_timer(1),"timeout")
	queue_free()


func _on_TouchArea_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		var collided_player = area.get_parent()
		
		if powerup.name == "Flamethrower":
			collided_player.kill(false)
		
		emit_signal("player_collision", collided_player)


func use_powerup():
	print("used " + powerup.name)
	match powerup.name:
		"none":
			pass
		
		"Double Jump":
			jump()
			powerup = CLEAR_POWERUP
		
		"Swap":
			#SWAP
			var Swap_Player = null
			var most_x_val = -1024
			var victums = get_tree().get_nodes_in_group("Player")
			for player in victums:
				if player != self and player.active and !player.is_respawning:
					if player.position.x >= most_x_val:
						Swap_Player = player
						most_x_val = player.position.x
			
			if Swap_Player == null:
				return
			
			var player1_pos = position
			var player2_pos = Swap_Player.position
			
			
			Swap_Player.position = player1_pos + Vector2(0, 50)
			position = player2_pos + Vector2(0, 50)
			
			
			powerup = CLEAR_POWERUP
			#END SWAP
		
		"Bomb":
			var get_players = get_tree().get_nodes_in_group("Player")
			for player in get_players:
				if position.distance_to(player.position) <= 250 and player != self:
					player.kill(false)
				
			powerup = {
				"name" : "Explode",
				"effect" : "explode",
				"time" : 1,
				"timeout" : 1
			}



