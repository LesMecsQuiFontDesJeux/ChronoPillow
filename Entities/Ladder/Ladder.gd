class_name Ladder
extends Node2D

var player_on_ladder: bool = false
var player_in_front_of_ladder: bool = false
var player_near_top: bool = false # New boolean to track if player is near top
var top_threshold: float = 20.0 # Distance from top to trigger near_top state

@onready var ladder_area: Area2D = $LadderArea

func _on_ladder_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_on_ladder = true
	center_player(body)
	$Camera2D.make_current()

func _on_ladder_area_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	# Only allow exiting if player is at the bottom of the ladder
	var player := body as Player
	var ladder_height = ladder_area.get_node("CollisionShape2D").shape.size.y
	if player.global_position.y < global_position.y + (ladder_height / 2):
		# If trying to exit from top, prevent it
		player_on_ladder = true
		center_player(player)
	else:
		player_on_ladder = false
		get_node("/root/World/Player/Camera2D").make_current()

func _on_ladder_front_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_in_front_of_ladder = true

func _on_ladder_front_area_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_in_front_of_ladder = false

func center_player(player: Node2D) -> void:
	var ladder_center_x = global_position.x
	var centered_position = Vector2(ladder_center_x, player.global_position.y)
	player.global_position = centered_position

func _physics_process(_delta: float) -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	if not player:
		return
	   
	if player_in_front_of_ladder:
		if not player_on_ladder and player.facing == Vector2.UP:
			# Player wants to climb up the ladder
			player.is_blocked = true
			player_on_ladder = true
			center_player(player)
		elif player_on_ladder and player.facing == Vector2.DOWN:
			# Player wants to get off the ladder
			# Only allow getting off if at the bottom of the ladder
			var ladder_height = ladder_area.get_node("CollisionShape2D").shape.size.y
			if player.global_position.y >= global_position.y + (ladder_height / 2):
				player.is_blocked = false
				player_on_ladder = false
				get_node("/root/World/Player/Camera2D").make_current()

	if player_on_ladder:
		var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var ladder_height = ladder_area.get_node("CollisionShape2D").shape.size.y
	   
		# Calculate ladder bounds from center
		var ladder_top = global_position.y - (ladder_height / 2)
		var ladder_bottom = global_position.y + (ladder_height / 2)
	   
		# Calculate new position before applying it
		var new_y_pos = player.global_position.y + (input_direction.y * player.speed * _delta)
	   
		# Clamp the position to stay within the ladder bounds
		new_y_pos = clamp(new_y_pos, ladder_top, ladder_bottom)
	   
		# Check if player is near the top of the ladder
		player_near_top = player.global_position.y <= (ladder_top + top_threshold)
	   
		# Apply the movement
		player.velocity = Vector2(0, input_direction.y * player.speed)
		player.global_position.y = new_y_pos
		player.global_position.x = global_position.x
	else:
		# Reset states when not on ladder
		player.is_blocked = false
		player_on_ladder = false
		player_near_top = false # Reset near_top state when off ladder
		get_node("/root/World/Player/Camera2D").make_current()
	if Input.is_action_just_pressed("interact"):
		print(player_near_top, get_tree().get_node_count_in_group("breaking_joint") == 0)
	if player_near_top and Input.is_action_just_pressed("interact") and get_tree().get_node_count_in_group("breaking_joint") == 0:
		GameManager.has_stopped_timer = true
		GameManager.time_manager.pause_day()

		var npc = load("res://Entities/NPCs/Bouhtade/Bouhtade.tscn")
		npc = npc.instantiate()
		npc.npc_name = "Alfred"
		npc.position = Vector2(10000, 10000)
		add_child(npc)
		var alfred: RigidBody2D = get_tree().get_first_node_in_group("god")
		if alfred != null:
			alfred.freeze = false
		npc.show_dialog("KEY_Alfred_Fin", true)

		print("Player has reached the top of the ladder and stopped the timer")
