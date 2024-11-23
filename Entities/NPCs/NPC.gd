class_name NPC
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var speed: float
@export var npc_name: String

var dialog_progress: float = 0
var dialog_indicator_sprite: AnimatedSprite2D
var dialog_window: Control
var player: Player
var world: World

var default_position: Vector2

func _enter_tree() -> void:
	world = get_node("/root/World")
	player = world.get_player()
	default_position = global_transform.origin

func _ready() -> void:
	add_to_group("npcs")
	_create_dialog_indicator()
	_create_dialog_window()
	play_animation("default")

func _create_dialog_indicator() -> void:
	var dialog_indicator: AnimatedSprite2D = load("res://Entities/NPCs/Art/DialogIndicator.tscn").instantiate()
	dialog_indicator.position = Vector2(2, -animated_sprite.sprite_frames.get_frame_texture("default", 0).get_height() / 2.0 - 3)
	dialog_indicator.play("default")
	dialog_indicator_sprite = dialog_indicator
	add_child(dialog_indicator)

func _create_dialog_window() -> void:
	pass

func move(move_velocity: Vector2) -> void:
	velocity = move_velocity
	move_and_slide()

func follow_player(delta: float, lerp_factor: float = 0.5, min_distance: float = 30) -> void:
	var direction = player.global_transform.origin - global_transform.origin
	var distance = direction.length()

	if distance < min_distance:
		return
	
	var target_position = global_transform.origin + direction.normalized() * speed * delta
	global_transform.origin = global_transform.origin.lerp(target_position, lerp_factor)

	if direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false

func go_to_default_position(delta: float, lerp_factor: float = 0.5) -> void:
	var direction = default_position - global_transform.origin
	var target_position = global_transform.origin + direction.normalized() * speed * delta
	global_transform.origin = global_transform.origin.lerp(target_position, lerp_factor)

func play_animation(animation_name: String) -> void:
	if animated_sprite.sprite_frames.has_animation(animation_name):
		animated_sprite.play(animation_name)
	else:
		animated_sprite.play("default")

func show_dialog() -> void:
	
	var formatted_dialog_key: String = "KEY_" + npc_name + "_" + str(dialog_progress)

	var dialog: String = tr(formatted_dialog_key)

	if dialog == formatted_dialog_key:
		dialog_progress = 0
		return

	dialog_progress += 1

	dialog_indicator_sprite.set_visible(false)
	_shift_camera_left()

	print(dialog)

func on_interact() -> void:
	show_dialog()
	
func _shift_camera_left() -> void:
	var camera: Camera2D = get_viewport().get_camera_2d()
	var tween: Tween = get_tree().create_tween()

	var offset: Vector2 = Vector2(camera.offset.x + get_viewport().size.x / 12, camera.offset.y)
	tween.tween_property(camera, "offset", offset, 1.0)
	tween.play()

func _shift_camera_right() -> void:
	var camera: Camera2D = get_viewport().get_camera_2d()
	var tween: Tween = get_tree().create_tween()

	var offset: Vector2 = Vector2(camera.offset.x - get_viewport().size.x / 12, camera.offset.y)
	tween.tween_property(camera, "offset", offset, 1.0)
	tween.play()
