extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_interact():
	"""
		When the player interacts with the item.
	"""
	var player: Player = get_tree().get_nodes_in_group("player")[0]
	if player.has_item() and player.get_item() is Bucket:
		var item: Item = player.get_item()
		item.animation = "full"
