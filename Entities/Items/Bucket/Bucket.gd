class_name Bucket
extends Item

var filled: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("items")

func on_interact():
	"""
		When the player interacts with the item.
	"""
