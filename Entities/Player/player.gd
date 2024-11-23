extends CharacterBody2D

@export var speed = 400
var facing = Vector2.DOWN
var idle = true
@onready var animated_sprite = $AnimatedSprite2D

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction.normalized() * speed

	if input_direction == Vector2.ZERO:
		if not idle:
			start_idle()
			idle = true		
	# Determine the current facing direction based on input
	if input_direction != Vector2.ZERO:
		var curr_facing = Vector2(input_direction.x, input_direction.y).normalized().round()

		if curr_facing != facing && curr_facing != Vector2.ZERO:
			idle = false
			facing = curr_facing
			start_walk()
	if Input.is_action_just_pressed("interact"):
		on_interact()

func start_idle():
	print("Idle")
	if facing == Vector2.DOWN:
		animated_sprite.play("walk_down")
		animated_sprite.stop()
	elif facing == Vector2.UP:
		animated_sprite.play("walk_up")
		animated_sprite.stop()
	elif facing == Vector2.LEFT:
		animated_sprite.play("idle_left")
	elif facing == Vector2.RIGHT:
		animated_sprite.play("idle_right")

func start_walk():
	print("Walking")
	if facing == Vector2.DOWN:
		animated_sprite.play("walk_down")
	elif facing == Vector2.UP:
		animated_sprite.play("walk_up")
	elif facing == Vector2.LEFT:
		animated_sprite.play("walk_left")
	elif facing == Vector2.RIGHT:
		animated_sprite.play("walk_right")
	
func on_interact():
	print("Interacting with something")

func _physics_process(_delta):
	get_input()
	move_and_slide()
