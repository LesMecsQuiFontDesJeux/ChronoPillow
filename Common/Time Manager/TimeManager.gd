class_name TimeManager
extends Node

enum TimeOfDay {
	Morning,
	Day,
	Night,
	Paused
}

const FULL_DAY_LENGTH: float = 10.0
const MORNING_END: float = 25.0
const DAY_END: float = 75.0

var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	timer.set_wait_time(FULL_DAY_LENGTH)
	timer.set_one_shot(true)
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout() -> void:
	stop_day()
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
	if timer.is_stopped():
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
