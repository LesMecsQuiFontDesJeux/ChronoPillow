class_name Cauldron
extends Node2D

const items = ["Rat", "Mushroom", "Bucket"]
@onready var sprite: AnimatedSprite2D = $Sprite2D

@onready var ratSlot: Node2D = $RatSlot
@onready var mushroomSlot: Node2D = $MushroomSlot
@onready var bucketSlot: Node2D = $BucketSlot

var full: bool = false

func on_interact():
	"""
		When the player interacts with the cauldron.
	"""
	print("Interacting with the cauldron")
	if full:
		print("Cauldron is full, creating potion")
		var potion_scene: PackedScene = ResourceLoader.load("res://Entities/Items/Potion/Potion.tscn")
		var potion: Potion = potion_scene.instantiate()
		potion.add_to_group("items")
		get_parent().add_child(potion)
		potion.global_position = global_position + Vector2(0, -20)
		var world: World = get_node("/root/World")
		world.get_npcs_by_name("Meowgician").show_dialog("KEY_Meowgician_BraveryPotionCooked")
		return
	var player: Player = get_tree().get_nodes_in_group("player")[0]
	if player.has_item():
		var item: Item = player.picked_up_item
		if items.has(item.item_name):
			if item.item_name == "Bucket" and not item.filled:
				print("Bucket is not filled")
				return
			print("Adding item to cauldron")
			player.drop_item()
			item.reparent(get_node(item.item_name + "Slot"))
			item.position = Vector2.ZERO
			item.scale = item.scale / 2
			item.add_to_group("held")
			if _all_slots_filled():
				print("Cauldron is full")
				# Show an animation where all items are joining together in the cauldron
				play_cauldron_animation([ratSlot, mushroomSlot, bucketSlot])
		else:
			print("Item not allowed in cauldron")
	else:
		print("No item to add to cauldron")

# Predefined slot where the items "combine" in the cauldron
const CAULDRON_CENTER = Vector2(0, 0)

# Assuming the Cauldron has a Tween node added
func play_cauldron_animation(items_in_cauldron):
	"""
	Animates items combining in the cauldron using Tween in Godot 4.
	:param items_in_cauldron: List of items added to the cauldron.
	"""
	var tween: Tween = get_tree().create_tween()
	tween.stop() # Stop any ongoing animations to avoid conflicts

	for item in items_in_cauldron:
		var end_position = Vector2(0, 0) # Cauldron's center, relative to the cauldron's node

		# Animate position
		tween.tween_property(
			item, "position", end_position, 1.0
		)
	# Start the Tween
	tween.play()

	# Optionally, connect the signal if not already connected
	tween.connect("finished", Callable(self, "_on_cauldron_animation_complete"))


func _on_cauldron_animation_complete():
	"""
	Callback for when the cauldron animation is complete.
	"""
	print("Cauldron animation complete!")
	# Trigger particle effects or other visual feedback here
	ratSlot.call_deferred("free")
	mushroomSlot.call_deferred("free")
	bucketSlot.call_deferred("free")
	var particles = get_node_or_null("Particles2D")
	if particles:
		particles.emitting = true
	
	sprite.animation = "full"

func _all_slots_filled():
	var rat: bool = ratSlot.get_children().size() > 0
	var mushroom: bool = mushroomSlot.get_children().size() > 0
	var bucket: bool = bucketSlot.get_children().size() > 0
	full = rat and mushroom and bucket
	return rat and mushroom and bucket
