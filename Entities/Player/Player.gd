class_name Player
extends CharacterBody2D

@export var speed = 200
var facing = Vector2.DOWN
var idle = true
@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea
@onready var item_slot = $ItemSlot


var picked_up_item: Item = null
func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction.normalized() * speed

	if input_direction == Vector2.ZERO:
		if not idle:
			start_idle()
			idle = true
	# Determine the current facing direction based on input
	if input_direction != Vector2.ZERO:
		var curr_facing = Vector2(input_direction.x, input_direction.y).normalized().round()

		if (curr_facing != facing or idle) && curr_facing != Vector2.ZERO:
			idle = false
			facing = curr_facing
			start_walk()
	if Input.is_action_just_pressed("interact"):
		interact()
	if Input.is_action_just_pressed("pickup"):
		print(picked_up_item)
		pick_up()

func play_animation(animation_name: String, stop: bool = false):
	animated_sprite.play(animation_name)
	if stop:
		animated_sprite.stop()

func start_idle():
	print("Starting idle")
	match facing:
		Vector2.DOWN, Vector2(-1, 1), Vector2(1, 1): # Down and diagonal down
			play_animation("walk_down", true)
			item_slot.position = Vector2(0, 8)
			item_slot.z_index = 1
		Vector2.UP, Vector2(-1, -1), Vector2(1, -1): # Up and diagonal up
			play_animation("walk_up", true)
			item_slot.position = Vector2(0, -8)
			item_slot.z_index = -1
		Vector2.LEFT:
			play_animation("idle_left")
			item_slot.position = Vector2(-8, 0)
			item_slot.z_index = 1
		Vector2.RIGHT:
			play_animation("idle_right")
			item_slot.position = Vector2(8, 0)
			item_slot.z_index = 1
func start_walk():
	print("Starting walk")
	match facing:
		Vector2.DOWN, Vector2(-1, 1), Vector2(1, 1): # Down and diagonal down
			play_animation("walk_down")
			item_slot.position = Vector2(0, 8)
			item_slot.z_index = 1
		Vector2.UP, Vector2(-1, -1), Vector2(1, -1): # Up and diagonal up
			play_animation("walk_up")
			item_slot.position = Vector2(0, -8)
			item_slot.z_index = -1
		Vector2.LEFT:
			play_animation("walk_left")
			item_slot.position = Vector2(-8, 0)
			item_slot.z_index = 1
		Vector2.RIGHT:
			play_animation("walk_right")
			item_slot.position = Vector2(8, 0)
			item_slot.z_index = 1
			
func interact():
	print("Interacting with something")
	if (has_item() and picked_up_item.is_in_group("interactable_held")):
		picked_up_item.on_interact()
	else:
		var entity = check_for_interactable()
		print(entity)
		if entity and entity.has_method("on_interact"):
			entity.on_interact()
		else:
			print("No interactable found")

func pick_up():
	if picked_up_item == null:
		print("Picking up item")
		var entity = check_for_interactable("items")
		print(entity, entity is Item)
		if entity and entity is Item:
			pick_up_item(entity)
		else:
			print("No item to pick up")
	else:
		drop_item()

func check_for_interactable(group: String = ""):
	var bodies = interaction_area.get_overlapping_areas()

	var closest_body = null
	var closest_distance = 0

	for body in bodies:
		print(body, body.get_parent())
		# Check if the body is in the specified group, or skip filtering if group is empty
		if (group == "" or body.get_parent().is_in_group(group)) and body.has_method("get_global_position"):
			if body.get_parent():
				if body.get_parent().is_in_group("held"):
					continue
				if body.get_parent().get_parent():
					if body.get_parent().get_parent().is_in_group("held"):
						continue
			var distance = global_position.distance_to(body.get_global_position())
			if closest_body == null or distance < closest_distance:
				closest_body = body
				closest_distance = distance

	if closest_body != null:
		print("Found closest body: ", closest_body.get_parent())
		return closest_body.get_parent()
	else:
		return null



func has_item():
	return picked_up_item != null

func get_item():
	return picked_up_item

func pick_up_item(item: Item):
	if picked_up_item == null:
		picked_up_item = item
		item.on_pickup()
		item.reparent(item_slot)
		item.add_to_group("held")
		item.position = Vector2.ZERO
		print("Picked up item: ", item.item_name)
	else:
		print("Already holding an item, swappping")
		drop_item()
		pick_up_item(item)
func drop_item():
	if picked_up_item != null:
		picked_up_item.global_position = global_position
		picked_up_item.remove_from_group("held")
		picked_up_item.reparent(get_parent())
		picked_up_item.on_drop()
		picked_up_item = null
		print("Dropped item")

func _physics_process(_delta):
	get_input()
	move_and_slide()
