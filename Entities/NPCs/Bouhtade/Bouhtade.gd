class_name Bouhtade
extends NPC

@onready var area2d: Area2D = $Area2D

var in_graveyard: bool = true
var evil: bool = false
var lerp_factor: float = 0.5
var min_distance: float = 30

func _physics_process(delta: float) -> void:

	if not in_graveyard and not evil:
		go_to_default_position(delta, lerp_factor)
		return

	if evil:
		for body in area2d.get_overlapping_bodies():
			if body.is_in_group("player"):
				body.die_from_bouhtade()
				set_physics_process(false)
				return

	if player.player_location == player.PlayerLocation.Graveyard and in_graveyard:
		follow_player(delta, lerp_factor, min_distance)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "GraveyardArea2D":
		in_graveyard = false

func unable_player_target_mode() -> void:
	evil = true
	dialog_indicator_sprite.set_visible(false)
	animated_sprite.play("evil_default")
	lerp_factor = 1.0
	min_distance = 5
