extends CharacterBody2D

@onready var hat: Node2D = %Hat
@export var healt := 100.0
@onready var progress_bar: ProgressBar = $ProgressBar


const SPEED := 500.0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
	if is_multiplayer_authority():
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false


func _physics_process(delta: float) -> void:
	progress_bar.value = healt
	
	# First check if we have authority over this player
	if not is_multiplayer_authority():
		return

	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED

	if Input.is_action_just_pressed("tire"):
		inst_bullet()

	move_and_slide()

	if Input.is_key_pressed(KEY_G):
		hat.scale += Vector2.ONE * delta
	if Input.is_key_pressed(KEY_S):
		hat.scale -= Vector2.ONE * delta

func inst_bullet():
	var bullet = load("res://bullet.tscn")
	var Inst_bullet = bullet.instantiate()
	Inst_bullet.position = position
	get_parent().add_child(Inst_bullet, true)
