class_name Potion
extends Item

func on_interact():
	"""
		When the player interacts with the item.
	"""
	var player: Player = get_tree().get_nodes_in_group("player")[0]
	player.drop_item()
	call_deferred("free")
	player.add_to_group("brave")
