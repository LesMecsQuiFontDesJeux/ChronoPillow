extends Node2D

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var randomStrength: float = 30.0
var shakeFade: float = 2.0

func _ready():
	set_physics_process(false)

var fused: bool = false
func on_interact() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")

	if player.get_item_on_head() is Lantern:
		fused = true
		print("Bomb has been fused")
		$FuseCPUParticles2D.emitting = true
		await get_tree().create_timer(4.0).timeout
		$FuseCPUParticles2D.emitting = false
		$ExplosionCPUParticles2D.emitting = true
		$Sprite2D.visible = false
		apply_shake()
		await get_tree().get_first_node_in_group("timer").blow_up_rope()
		await get_tree().create_timer(2.0).timeout
		set_physics_process(false)
		var world: World = get_node("/root/World")
		world.get_npcs_by_name("Martin").show_dialog("KEY_Martin_Explosion")
		call_deferred("free")


func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func apply_shake():
	shake_strength = randomStrength
	set_physics_process(true)

func _physics_process(delta):
	if shake_strength > 0:
			shake_strength = lerp(shake_strength, 0.0, shakeFade * delta)
			get_viewport().get_camera_2d().offset = randomOffset()
