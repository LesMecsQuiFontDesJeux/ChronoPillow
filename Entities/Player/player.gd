extends CharacterBody2D

@export var speed = 200
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

		if (curr_facing != facing or idle) && curr_facing != Vector2.ZERO:
			idle = false
			facing = curr_facing
			start_walk()
	if Input.is_action_just_pressed("interact"):
		on_interact()

func play_animation(animation_name: String, stop: bool = false):
	animated_sprite.play(animation_name)
	if stop:
		animated_sprite.stop()

func start_idle():
	print("Idle")
	match facing:
		Vector2.DOWN, Vector2(-1, 1), Vector2(1, 1): # Down and diagonal down
			play_animation("walk_down", true)
		Vector2.UP, Vector2(-1, -1), Vector2(1, -1): # Up and diagonal up
			play_animation("walk_up", true)
		Vector2.LEFT:
			play_animation("idle_left")
		Vector2.RIGHT:
			play_animation("idle_right")

func start_walk():
	print("Walking")
	match facing:
		Vector2.DOWN, Vector2(-1, 1), Vector2(1, 1): # Down and diagonal down
			play_animation("walk_down")
		Vector2.UP, Vector2(-1, -1), Vector2(1, -1): # Up and diagonal up
			play_animation("walk_up")
		Vector2.LEFT:
			play_animation("walk_left")
		Vector2.RIGHT:
			play_animation("walk_right")
			
func on_interact():
	print("Interacting with something")

func _physics_process(_delta):
	get_input()
	move_and_slide()
