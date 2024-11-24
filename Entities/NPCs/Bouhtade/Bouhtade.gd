class_name Bouhtade
extends NPC

@onready var area2d: Area2D = $Area2D

var in_graveyard: bool = true
var evil: bool = false
var lerp_factor: float = 0.5
var min_distance: float = 30

var spirit_pieces: int = 4

func _physics_process(delta: float) -> void:

	if evil and GameManager.is_brave:
		for body in area2d.get_overlapping_bodies():
			if body.is_in_group("player"):
				body.die_from_bouhtade()
				set_physics_process(false)
				return

	if (not in_graveyard and not evil) or player.player_location != player.PlayerLocation.Graveyard:
		go_to_default_position(delta, lerp_factor)
		return

	if player.player_location == player.PlayerLocation.Graveyard and in_graveyard:
		follow_player(delta, lerp_factor, min_distance)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "GraveyardArea2D" and evil and not GameManager.is_brave:
		in_graveyard = false
	if area.name == "GraveyardArea2D" and not evil:
		in_graveyard = false

func unable_player_target_mode() -> void:
	evil = true
	dialog_indicator_sprite.set_visible(false)
	animated_sprite.play("evil_default")
	lerp_factor = 1.0
	min_distance = 5

func unable_player_to_enter_target_mode() -> void:
	evil = true
	dialog_indicator_sprite.set_visible(false)
	animated_sprite.play("evil_default")
	lerp_factor = 3.0
	min_distance = 20
	$CollisionShape2D.call_deferred("set_disabled", false)

func disable_unable_player_to_enter_target_mode() -> void:
	evil = false
	dialog_indicator_sprite.set_visible(true)
	animated_sprite.play("default")
	lerp_factor = 0.5
	min_distance = 30
	$CollisionShape2D.call_deferred("set_disabled", true)


func gather_spirit_piece() -> void:
	spirit_pieces -= 1

	if spirit_pieces == 0:
		show_dialog("KEY_Bouhtade_CollectedAllSpiritPieces")
		var lantern: Item = load("res://Entities/Items/Lantern/Lantern.tscn").instantiate()
		lantern.position = global_position + Vector2(0, -5)
		var world = get_node("/root/World")
		world.add_child(lantern)
