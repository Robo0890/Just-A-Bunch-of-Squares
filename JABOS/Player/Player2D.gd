extends KinematicBody2D


var velocity = Vector2(0, 0)
var jumpVelocity = -220
var start_pos = Vector2(0,0)
var alive = true
var jumps = 0
var last_platform = null

var total_jumps = 0
var falls = 0

export var follow_camera = false
export var gravity = 9.81
export var speed = .5
export var max_jumps = 1
export var constant_movement = false
export var wall_jump = false
export var hook = true
export var respawn = false

var player_name = "p1_"
var color = 0
var player = 0

func _ready():
	$Sprite.modulate = Color.from_hsv(color,1,1)
	start_pos = position

func _on_death():
	$CollisionShape.disabled = true
	falls += 1
	position = start_pos - Vector2(0,250)

func _physics_process(delta):
	move(delta)
	if Input.is_action_just_pressed(player_name + "quit") and !get_parent().start:
		get_parent().active_players.erase(player)
		get_parent().players -= 1
		get_parent().ready_players = []
		get_parent().get_node("Camera/Control/GuiHandler")._ready()
		if get_parent().active_players.size() == 0:
# warning-ignore:return_value_discarded
			Global.players_active.erase(player)
			get_tree().change_scene("res://StartScreen.tscn")
		queue_free()
	if position.y >= 500:
		_on_death()
	if position.distance_to(start_pos) <= 10 and $CollisionShape.disabled:
		$CollisionShape.disabled = false

# warning-ignore:unused_argument
func move(delta):
	apply_velocity()
	apply_gravity()
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.UP)

func apply_velocity():
	if !constant_movement:
		var movex = (Input.get_action_strength(player_name + "movement_right") - Input.get_action_strength(player_name + "movement_left")) * 500
# warning-ignore:unused_variable
		var movey = (Input.get_action_strength(player_name + "movement_left") - Input.get_action_strength(player_name + "movement_right")) * 500
		velocity.x = movex * speed
	else:
		velocity.x = 100
	if $CollisionShape.disabled:
		velocity.x = 0


func apply_gravity():
	if is_on_floor():
		if velocity.y > 300:
			pass
		velocity.y = -10
		jumps = 0
		if $Area.is_colliding() and !$Area.get_collider().is_in_group("Player"):
			start_pos = position
			
	if !$CollisionShape.disabled and Input.is_action_just_pressed(player_name + "movement_jump") and jumps != max_jumps:
		velocity.y = jumpVelocity
		jumps += 1
		total_jumps += 1
	else:
		velocity.y += gravity
	if is_on_wall() and wall_jump:
		jumps = max_jumps - 1
		velocity.x = 0
		
	if is_on_ceiling() and Input.is_action_pressed(player_name + "movement_jump") and hook:
		velocity.y = -10
		if Input.is_action_just_pressed(player_name + "flip"):
			hook_flip()
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2(0, -1)) 

func hook_flip():
	$CollisionShape.disabled = true
	position.y -= 100
	if is_on_floor():
		hook_flip()
	else:
		$CollisionShape.disabled = false
