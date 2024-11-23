class_name World
extends Node2D

@onready var directional_light: DirectionalLight2D = $DirectionalLight2D

func get_pillow() -> Pillow:
	return get_node("Pillow")

func update_lighting(time_of_day: TimeManager.TimeOfDay) -> void:
	match time_of_day:
		TimeManager.TimeOfDay.Morning:
			directional_light.color = TimeManager.MORNING_COLOR
		TimeManager.TimeOfDay.Day:
			directional_light.color = TimeManager.DAY_COLOR
		TimeManager.TimeOfDay.Night:
			directional_light.color = TimeManager.NIGHT_COLOR

func get_player() -> Player:
	return get_node("Player")
