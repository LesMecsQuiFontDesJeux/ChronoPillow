extends Node

var time_manager: TimeManager
var day: int = 0
var stored_item_name = null
var is_brave: bool = false
var has_stopped_timer: bool = false
var has_lantern: bool = false

func _ready() -> void:
	set_physics_process(false)
	time_manager = TimeManager.new()
	add_child(time_manager)

func start_game() -> void:
	is_brave = false
	has_stopped_timer = false
	has_lantern = false
	day = 0
	stored_item_name = null
	start_day(true)

func setup_time_manager(player: Player) -> void:
	player.connect("died", time_manager.on_player_died)

func start_day(first_day: bool = false) -> void:
	var new_world: PackedScene = preload("res://Stages/World/World.tscn")
	var world: World = new_world.instantiate()
	var pillow: Pillow = world.get_pillow()
	var player: Player = world.get_player()
	if has_lantern:
		var lantern: Item = load("res://Entities/Items/Lantern/Lantern.tscn").instantiate()
		world.add_child(lantern)
		player.place_on_head(lantern)


	if not first_day and stored_item_name != null:
		pillow.set_stored_item_name(stored_item_name)

	time_manager.start_day()
	get_tree().get_root().add_child.call_deferred(world)
	world.circular_fade_in()
	call_deferred("setup_time_manager", world.get_player())
	call_deferred("set_physics_process", true)
	if first_day:
		call_deferred("show_pillow")

func show_pillow():
	var world: World = get_node("/root/World")
	var pillow: Pillow = world.get_pillow()
	pillow.set_stored_item_name("Letter")
	var item: Item = pillow.retrieve_item()
	item.position = Vector2.ZERO
	pillow.sprite.global_position += Vector2(0, 10)

func end_day(win: bool = false) -> void:
	var world: World = get_node("/root/World")
	var player: Player = world.get_player()
	var pillow: Pillow = world.get_pillow()
	
	stored_item_name = pillow.get_stored_item_name()

	set_physics_process(false)
	world.call_deferred("free")

	day += 1

	if win:
		var menu: MainMenu = get_node("/root/MainMenu")
		menu.win()
	else:
		start_day()

func _physics_process(_delta):
	var world: World = get_node("/root/World")
	if world == null:
		return
	world.update_lighting(time_manager.get_day_state())
