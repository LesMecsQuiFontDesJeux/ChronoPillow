extends Node

var time_manager: TimeManager
var day: int = 0
var stored_item_name = null
var is_brave: bool = false

const TARGET_WIDTH: float = 1280.0
const TARGET_HEIGHT: float = 720.0
const BASE_ZOOM = 4

var scale_ratio: float = 1.0

func _ready() -> void:
	set_physics_process(false)
	time_manager = TimeManager.new()
	add_child(time_manager)

func start_game() -> void:
	start_day(true)

func setup_time_manager(player: Player) -> void:
	player.connect("died", time_manager.on_player_died)

func start_day(first_day: bool = false) -> void:
	var new_world: PackedScene = preload("res://Stages/World/World.tscn")
	var world: World = new_world.instantiate()
	var pillow: Pillow = world.get_pillow()

	if first_day:
		#pillow.set_stored_item_name("")
		pass
		
	if not first_day and stored_item_name != null:
		pillow.set_stored_item_name(stored_item_name)

	time_manager.start_day()
	get_tree().get_root().add_child.call_deferred(world)
	world.circular_fade_in()
	call_deferred("setup_time_manager", world.get_player())
	call_deferred("set_physics_process", true)

	call_deferred("zoom_to_fit")

func end_day(player_died: bool = false) -> void:
	var world: World = get_node("/root/World")
	var player: Player = world.get_player()
	var pillow: Pillow = world.get_pillow()

	# if player.is_in_group("brave") and not is_brave:
	# 	is_brave = true
	
	if not player_died:
		stored_item_name = pillow.get_stored_item_name()
	else:
		stored_item_name = pillow.get_last_item()

	set_physics_process(false)
	world.call_deferred("free")

	day += 1
	start_day()

func _physics_process(_delta):
	var world: World = get_node("/root/World")
	if world == null:
		return
	world.update_lighting(time_manager.get_day_state())
	zoom_to_fit()

func zoom_to_fit() -> void:
	var viewport_size = get_viewport().size
	var width_ratio: float = viewport_size.x / TARGET_WIDTH
	var height_ratio: float = viewport_size.y / TARGET_HEIGHT
	scale_ratio = min(width_ratio, height_ratio)
	
	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera != null:
		camera.zoom = Vector2(BASE_ZOOM * scale_ratio, BASE_ZOOM * scale_ratio)
