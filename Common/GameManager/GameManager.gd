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

func start_day(first_day: bool = false) -> void:
	var new_world: PackedScene = load("res://Stages/World/World.tscn")
	var world: World = new_world.instantiate()
	var pillow: Pillow = world.get_pillow()

	if first_day:
		#pillow.set_stored_item_name("")
		pass
		
	if not first_day and stored_item_name != null:
		pillow.set_stored_item_name(stored_item_name)

	time_manager.start_day()
	get_tree().get_root().add_child.call_deferred(world)
	call_deferred("set_physics_process", true)


func end_day(player_killed: bool = false) -> void:
	var world: World = get_node("/root/World")
	# var player: Player = world.get_player()
	
	if not player_killed:
		stored_item_name = world.get_pillow().get_stored_item_name()

	# if player_killed:
		# ????

	set_physics_process(false)
	for child in get_tree().get_root().get_children():
		if child != self:
			child.queue_free()

	day += 1

	await get_tree().create_timer(2.0).timeout
	start_day()

func _physics_process(_delta):
	var world: World = get_node("/root/World")
	world.update_lighting(time_manager.get_day_state())
