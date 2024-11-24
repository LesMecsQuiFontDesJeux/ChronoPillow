class_name Item
extends Node2D

@export var item_name: String = "Item"
var is_pickable: bool = true
var in_cave: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("items")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_cave:
		z_index = -3
	else:
		z_index = 0

func on_interact():
	"""
		When the player interacts with the item.
	"""
	pass

func on_pickup():
	"""
		When the player picks up the item.
	"""
	pass
func on_drop():
	"""
		When the player drops the item.
	"""
	pass
