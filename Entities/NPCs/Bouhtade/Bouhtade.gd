class_name Bouhtade
extends NPC

var evil: bool = false

func _physics_process(delta: float) -> void:
	follow_player(delta, 0.5, 30)

func _process(_delta: float) -> void:
	if GameManager.time_manager.get_day_state() == TimeManager.TimeOfDay.Morning:
		evil = true
	else:
		evil = false
