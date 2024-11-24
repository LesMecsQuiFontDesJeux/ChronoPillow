class_name World
extends Node2D

@onready var directional_light: DirectionalLight2D = $Sun

@onready var overworld_layers: Array = $OverworldLayers.get_children()
@onready var cave_layers: Array = $CaveLayers.get_children()

func _ready() -> void:
	_on_house_outside_door_area_2d_body_entered(get_node("Player"))

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

func get_npcs_by_name(npc_name: String) -> NPC:
	var npcs = get_tree().get_nodes_in_group("npcs")
	for npc in npcs:
		if npc.npc_name == npc_name:
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

		body.player_location = Player.PlayerLocation.House

		for door in get_tree().get_nodes_in_group("doorsoutside"):
			door.set_deferred("disabled", true)
		for door in get_tree().get_nodes_in_group("doorsinside"):
			door.set_deferred("disabled", false)
		_set_items_visibility(body, true)
		_set_layers_visibility_and_collision(overworld_layers, false)
		_set_layers_visibility_and_collision(cave_layers, true)
	else:
		_set_layers_visibility_and_collision(overworld_layers, true)
		_set_layers_visibility_and_collision(cave_layers, false)
		
func _on_house_inside_door_area_2d_body_entered(body: Node2D) -> void:


	if body.is_in_group("player"):

		body.player_location = Player.PlayerLocation.Plain
	
		for door in get_tree().get_nodes_in_group("doorsinside"):
			door.set_deferred("disabled", true)
		for door in get_tree().get_nodes_in_group("doorsoutside"):
			door.set_deferred("disabled", false)
		_set_items_visibility(body, false)
		_set_layers_visibility_and_collision(overworld_layers, true)
		_set_layers_visibility_and_collision(cave_layers, false)
	else:
		_set_layers_visibility_and_collision(overworld_layers, false)
		_set_layers_visibility_and_collision(cave_layers, true)

func _on_cave_enter(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Darkness.visible = true
		$Sun.visible = false

func _on_cave_exit(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Darkness.visible = false
		$Sun.visible = true
	
func _set_layers_visibility_and_collision(layers: Array, enabled: bool) -> void:
	for layer in layers:
		layer.visible = enabled
		layer.collision_enabled = enabled

func _set_items_visibility(body: Player, in_cave: bool) -> void:
	var item: Item = body.get_item()
	if item != null:
		item.in_cave = in_cave
		if in_cave:
			body.z_index_item_slot.merge({"down": 4}, true)
		else:
			body.z_index_item_slot.merge({"down": 1}, true)

	for tree_item in get_tree().get_nodes_in_group("items"):
		if tree_item != get_player().get_item_on_head():
			if tree_item.in_cave:
				tree_item.visible = in_cave
			else:
				tree_item.visible = !in_cave
