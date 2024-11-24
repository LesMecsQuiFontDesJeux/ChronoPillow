class_name TimeManager
extends Node

enum TimeOfDay {
	Morning,
	Day,
	Night,
	Paused
}

const FULL_DAY_LENGTH: float = 100.0
const MORNING_END: float = 25.0
const DAY_END: float = 75.0

const MORNING_COLOR: Color = Color(1.0, 0.6, 0.2)
const DAY_COLOR: Color = Color(1.0, 1.0, 1.0)
const NIGHT_COLOR: Color = Color(0.2, 0.2, 0.2)

var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(FULL_DAY_LENGTH)
	timer.set_one_shot(true)
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	stop_day()

	var world: World = get_node("/root/World")
	var player: Player = world.get_player()
	if player.player_location == player.PlayerLocation.Graveyard:
		var bouhtade: Bouhtade = world.get_npcs_by_name("Bouhtade")
		bouhtade.unable_player_target_mode()
		return
	# elif ...:
	# 	...
	#   return
	
	GameManager.end_day()

func on_player_died() -> void:
	var world: World = get_node("/root/World")
	await get_tree().create_timer(0.5).timeout
	world.circular_fade_out()
	await get_tree().create_timer(1.0).timeout
	GameManager.end_day()

func start_day() -> void:
	timer.set_wait_time(FULL_DAY_LENGTH)
	timer.start()

func stop_day() -> void:
	timer.stop()

func pause_day() -> void:
	timer.set_paused(true)

func resume_day() -> void:
	timer.set_paused(false)

func get_day_state() -> TimeOfDay:
	if timer.paused:
		return TimeOfDay.Paused
	
	var time: float = FULL_DAY_LENGTH - timer.get_time_left()
	if time < MORNING_END:
		return TimeOfDay.Morning
	elif time < DAY_END:
		return TimeOfDay.Day
	else:
		return TimeOfDay.Night

func get_time_left() -> float:
	return timer.get_time_left()

func get_time_passed() -> float:
	return FULL_DAY_LENGTH - timer.get_time_left()

func get_normalized_time_passed() -> float:
	return get_time_passed() / FULL_DAY_LENGTH
