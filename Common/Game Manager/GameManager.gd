extends Node

var time_manager: TimeManager

var day: int = 0
var stored_item: Item

func _ready() -> void:
	set_physics_process(false)
	time_manager = TimeManager.new()
	add_child(time_manager)

func start_game() -> void:
	start_day(true)

func start_day(first_day: bool = false) -> void:
	var new_world: PackedScene = load("res://Stages/World/World.tscn")
	var world: World = new_world.instantiate()

	# if first_day:
		# add the letter under the pillow

	# if not first_day:
		# world.get_pillow().set_stored_item(stored_item)

	time_manager.start_day()
	get_tree().get_root().add_child.call_deferred(world)
	call_deferred("set_physics_process", true)


func end_day(player_killed: bool = false) -> void:
	var world: World = get_node("/root/World")
	# var player: Player = world.get_player()
	
	# if not player_killed:
		# stored_item = world.get_pillow().get_stored_item().duplicate()

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
	var directional_light: DirectionalLight2D = get_node("/root/World/DirectionalLight2D")
	var time_of_day: TimeManager.TimeOfDay = time_manager.get_day_state()

	if time_of_day == TimeManager.TimeOfDay.Morning:
		directional_light.color = time_manager.MORNING_COLOR
	elif time_of_day == TimeManager.TimeOfDay.Day:
		directional_light.color = time_manager.DAY_COLOR
	elif time_of_day == TimeManager.TimeOfDay.Night:
		directional_light.color = time_manager.NIGHT_COLOR
