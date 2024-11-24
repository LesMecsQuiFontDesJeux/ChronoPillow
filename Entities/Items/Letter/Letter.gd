extends Item

var letter_visible = false
func on_interact() -> void:
	letter_visible = not letter_visible
	get_node('/root/World/HUD/LetterPopup').visible = letter_visible