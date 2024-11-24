extends Node2D

var fused: bool = false
func on_interact() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")

	if player.get_head_item() is Lantern:
		fused = true
		print("Bomb has been fused")
		$FuseCPUParticles2D.emitting = true
		await get_tree().create_timer(4.0).timeout
		$FuseCPUParticles2D.emitting = false
		$ExplosionCPUParticles2D.emitting = true
		$Sprite2D.visible = false
		await get_tree().get_first_node_in_group("timer").blow_up_rope()
