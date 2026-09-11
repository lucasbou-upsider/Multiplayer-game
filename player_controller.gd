extends CharacterBody2D

@onready var hat: Node2D = %Hat
@export var healt := 100.0
@onready var progress_bar: ProgressBar = $ProgressBar


const SPEED := 500.0

func _ready() -> void:
	print("Joueur créé, path: ", get_path(), " sur peer id: ", multiplayer.get_unique_id())



func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
	if is_multiplayer_authority():
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false


func _physics_process(delta: float) -> void:
	# First check if we have authority over this player
	if not is_multiplayer_authority():
		return

	progress_bar.value = healt

	look_at(get_global_mouse_position()) 
	rotation += 90

	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED

	if Input.is_action_just_pressed("tire"):
		request_bullet.rpc()
		print("aaaa")
	if Input.is_action_just_pressed("ui_select"):
		$Icon.scale = Vector2(500, 50)
		

	move_and_slide()

	if Input.is_key_pressed(KEY_G):
		hat.scale += Vector2.ONE * delta
	if Input.is_key_pressed(KEY_S):
		hat.scale -= Vector2.ONE * delta

var bullet = preload("res://bullet.tscn")


@rpc("any_peer","call_local", "reliable")
func request_bullet() -> void:
	if not multiplayer.is_server():
		return

	print("azeaze")
	var insbullet = bullet.instantiate()
	insbullet.position = global_position
	get_parent().add_child(insbullet, true)
