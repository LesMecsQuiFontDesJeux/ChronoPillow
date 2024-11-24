class_name Pillow
extends Node2D

"""
	The pillow is a single item container allowing the player to keep an item through the days
"""

@onready var sprite: Sprite2D = $Sprite2D
@onready var item_slot: Node2D = $ItemSlot
var stored_item_name = null
var last_item = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func get_stored_item_name():
	return stored_item_name

func get_last_item():
	return last_item

func set_stored_item_name(item_name: String):
	stored_item_name = item_name

func on_interact():
	"""
		When the player interacts with the item.
	"""
	# Get the player
	var player: Player = get_tree().get_nodes_in_group("player")[0]
	if player.has_item():
		if stored_item_name == null:
			var item: Item = player.picked_up_item
			player.drop_item()
			store_item(item)
		else:
			print("Already holding an item, swappping")
			var item: Item = player.picked_up_item
			player.drop_item()
			player.pick_up_item(retrieve_item())
			store_item(item)
	else:
		if stored_item_name != null:
			var item: Item = retrieve_item()
			item.position = Vector2.ZERO
			sprite.global_position.y += 10
		else:
			print("No item to pick up")

func store_item(item: Item):
	stored_item_name = item.item_name
	item.on_drop()
	item.call_deferred("free")

func retrieve_item() -> Item:
	var scene: PackedScene = ResourceLoader.load("res://Entities/Items/" + stored_item_name + "/" + stored_item_name + ".tscn")
	var item: Item = scene.instantiate()
	item.in_cave = true
	item_slot.add_child(item)
	last_item = item
	stored_item_name = null
	return item

func _on_item_slot_child_exiting_tree(_node: Node) -> void:
	sprite.global_position.y -= 10
