class_name Letter
extends Item

var letter_visible = false
func on_interact() -> void:
	letter_visible = not letter_visible
	if letter_visible:
		add_to_group("undroppable")
	else:
		remove_from_group("undroppable")
	get_node('/root/World/HUD/LetterPopup').visible = letter_visible