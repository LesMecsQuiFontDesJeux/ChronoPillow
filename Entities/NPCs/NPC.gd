class_name NPC
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var speed: float
@export var npc_name: String

var dialog_progress: float = 0
var dialog_indicator_sprite: AnimatedSprite2D
var dialog_window: Control

func _ready() -> void:
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

func move(direction: Vector2) -> void:
	velocity = direction * speed
	move_and_slide()

func play_animation(animation_name: String) -> void:
	if animated_sprite.sprite_frames.has_animation(animation_name):
		animated_sprite.play(animation_name)
	else:
		animated_sprite.play("default")

func show_dialog(dialog_key: String) -> void:
	
	var formatted_dialog_key: String = dialog_key + "_" + str(dialog_progress)

	var dialog: String = tr(formatted_dialog_key)

	if dialog == formatted_dialog_key:
		dialog_progress = 0
		return

	dialog_progress += 1

	dialog_indicator_sprite.set_visible(false)
	_shift_camera_left()

	print(dialog)

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
