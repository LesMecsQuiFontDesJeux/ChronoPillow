extends Node

var time_manager: TimeManager
var day: int = 0
var stored_item_name = null

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

func end_day(player_killed: bool = false) -> void:
	var world: World = get_node("/root/World")
	
	if not player_killed:
		stored_item_name = world.get_pillow().get_stored_item_name()

	set_physics_process(false)
	world.call_deferred("free")

	day += 1
	start_day()

func _physics_process(_delta):
	var world: World = get_node("/root/World")
	if world == null:
		return
	world.update_lighting(time_manager.get_day_state())