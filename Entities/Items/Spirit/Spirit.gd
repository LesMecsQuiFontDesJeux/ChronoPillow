class_name Spirit
extends Item


func on_interact():
	var world: World = get_node("/root/World")
	var player: Player = world.get_player()
	player.drop_item()
	call_deferred("free")
	var bouhtade: Bouhtade = world.get_npcs_by_name("Bouhtade")
	bouhtade.gather_spirit_piece()
