class_name World
extends Node2D

@onready var directional_light: DirectionalLight2D = $DirectionalLight2D

@onready var overworld_layers: Array = $OverworldLayers.get_children()
@onready var cave_layers: Array = $CaveLayers.get_children()

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

func get_npcs_by_name(name: String) -> NPC:
	var npcs = get_tree().get_nodes_in_group("npcs")
	for npc in npcs:
		if npc.npc_name == name:
			return npc
	return null

func circular_fade_in() -> void:
	var fade_in: AnimationPlayer = $Transitions/CircularFadeInOut/AnimationPlayer
	fade_in.play("fade_in")

func circular_fade_out() -> void:
	var fade_out: AnimationPlayer = $Transitions/CircularFadeInOut/AnimationPlayer
	fade_out.play("fade_out")

func _on_house_outside_door_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$HouseOutsideDoorArea2D/CollisionShape2D.set_deferred("disabled", true)
		$HouseInsideDoorArea2D/CollisionShape2D.set_deferred("disabled", false)
		_set_layers_visibility_and_collision(overworld_layers, false)
		_set_layers_visibility_and_collision(cave_layers, true)
	else:
		_set_layers_visibility_and_collision(overworld_layers, true)
		_set_layers_visibility_and_collision(cave_layers, false)
		
func _on_house_inside_door_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$HouseInsideDoorArea2D/CollisionShape2D.set_deferred("disabled", true)
		$HouseOutsideDoorArea2D/CollisionShape2D.set_deferred("disabled", false)
		_set_layers_visibility_and_collision(overworld_layers, true)
		_set_layers_visibility_and_collision(cave_layers, false)
	else:
		_set_layers_visibility_and_collision(overworld_layers, false)
		_set_layers_visibility_and_collision(cave_layers, true)
	pass

func _set_layers_visibility_and_collision(layers: Array, enabled: bool) -> void:
	for layer in layers:
		layer.visible = enabled
		layer.collision_enabled = enabled
