extends CharacterBody2D
class_name Player


const SPEED = 150.0
const HIGHSPEED = 450.0
const ACCEL = 20.0
const JUMP_VELOCITY = -400.0

var maxHP = 100
var hp

#player state
var speedup = false
var speedupTimer
var invincible = false

#weapons
const basic_bubble_shooter_template = preload("res://scenes/game/weapons/basic_bubble_shooter.tscn")
var weapons: Array[BasicBubbleShooter] = [null, null, null, null, null, null]

#variables for referencing nodes
var HPBar

func _ready():
	HPBar = get_node("HPBar")
	hp = maxHP
	HPBar.max_value = maxHP
	HPBar.value = hp
	
	# instantiate weapons
	# TODO: 2 hardcoded basic weapons for now, for testing
	weapons[0] = basic_bubble_shooter_template.instantiate()
	add_child(weapons[0])
	weapons[0].global_position = Vector2(50, 0)
	
	weapons[1] = basic_bubble_shooter_template.instantiate()
	add_child(weapons[1])
	weapons[1].global_position = Vector2(-50, 0)
	
	#this should ultimately all get triggered from somewhere else
	#await get_tree().create_timer(5).timeout
	#activateSpeedup()

func _physics_process(delta: float) -> void:
	
	 # 8 Direction movement inputs
	var direction := Input.get_vector("move_left", "move_right","move_up", "move_down")
	
	# This will have the player deaccelerate
	if !speedup:
		velocity = lerp(velocity, direction * SPEED, ACCEL * delta)
	else:
		velocity = lerp(velocity, direction * HIGHSPEED, ACCEL * delta)
	# This moves the character
	move_and_slide()
	
	_attack()

func _attack():
	
	# Recieves input to attack
	if Input.is_action_just_pressed("attack"):
		if weapons[0] != null:
			weapons[0].shoot()

#region Power-Ups

func on_powerup_collide(item : PowerUp.Types):
	match item:
		PowerUp.Types.SPEEDUP:
			activateSpeedup()

func activateSpeedup():
	speedup = true
	var timeLeft
	if is_instance_valid(speedupTimer):
		timeLeft = speedupTimer.time_left
	else:
		timeLeft = 0
	if(timeLeft > 0.1):
		speedupTimer.time_left = 10
	else:
		speedupTimer = get_tree().create_timer(10)
	await speedupTimer.timeout
	speedup = false
	
#endregion

	
