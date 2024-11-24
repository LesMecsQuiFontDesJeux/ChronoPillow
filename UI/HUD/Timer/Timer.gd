extends Control

@onready var timer_text: Label = $GravityOverride/Timer/TextureRect/Label 
@onready var rope_joint: PinJoint2D = $GravityOverride/RightRope/RR_T
@onready var timer_texture: TextureRect = $GravityOverride/Timer/TextureRect
func _physics_process(delta: float) -> void:
	timer_text.text = str(floor(GameManager.time_manager.get_time_left()))

func blow_up_rope() -> void:
	rope_joint.call_deferred("free")

func pause_timer() -> void:
	GameManager.time_manager.pause_day()
	timer_texture.texture = load("res://UI/HUD/Timer/Art/TimerPaused.png")

func resume_timer() -> void:
	GameManager.time_manager.resume_day()
	timer_texture.texture = load("res://UI/HUD/Timer/Art/TimerPlaying.png")
