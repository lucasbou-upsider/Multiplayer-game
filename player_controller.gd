extends CharacterBody2D

@onready var hat: Node2D = %Hat
@export var healt := 100.0
@onready var progress_bar: ProgressBar = $ProgressBar


const SPEED := 500.0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("tire"):
		var bullet = load("res://bullet.tscn").instantiate()
		get_parent().add_child(bullet, true)
		bullet.position = position + Vector2(200,0)
		
	
	
	progress_bar.value = healt
	
	# First check if we have authority over this player
	if not is_multiplayer_authority():
		return

	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED

	move_and_slide()

	if Input.is_key_pressed(KEY_G):
		hat.scale += Vector2.ONE * delta
	if Input.is_key_pressed(KEY_S):
		hat.scale -= Vector2.ONE * delta
