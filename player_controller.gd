extends CharacterBody2D

@onready var hat: Node2D = %Hat
@export var healt := 100.0
@onready var progress_bar: ProgressBar = $ProgressBar


var SPEED := 500.0

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

	velocity = Input.get_vector("gauch", "droite", "haut", "droite") * SPEED

	if Input.is_action_just_pressed("tire"):
		request_bullet.rpc()
		print("aaaa")
	if Input.is_action_just_pressed("ui_select"):
		if $Timer.time_left == 0:
			SPEED += 3000
			$Timer.start()
		

	move_and_slide()


var bullet = preload("res://bullet.tscn")


@rpc("any_peer","call_local","reliable")
func request_bullet() -> void:
	if not multiplayer.is_server():
		return

	print("azeaze")
	var insbullet = bullet.instantiate()
	insbullet.position = global_position
	get_parent().add_child(insbullet, true)


func _on_timer_timeout() -> void:
	if not is_multiplayer_authority():
		return
	
	SPEED = 500.0
	
