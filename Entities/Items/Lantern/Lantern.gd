extends Item

func on_interact():
	var player: Player = get_tree().get_nodes_in_group("player")[0]
	player.place_on_head(self)