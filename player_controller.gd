extends CharacterBody2D

@onready var roue: AnimatedSprite2D = $Roue
@export var healt := 100.0
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var tete: AnimatedSprite2D = $Tete
var bullet = preload("res://bullet.tscn")
var Speed := 500.0


func _ready() -> void:
	print("Joueur créé, path: ", get_path(), " sur peer id: ", multiplayer.get_unique_id())



func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
	if is_multiplayer_authority():
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false


func _physics_process(_delta: float) -> void:
	# First check if we have authority over this player
	if not is_multiplayer_authority():
		return

	animation()
	progress_bar.value = healt
	
	tete.look_at(get_global_mouse_position()) 
	#tete.rotation += 89.6

	velocity = Input.get_vector("gauch", "droite", "haut", "bas") * Speed
	print(velocity)

	if Input.is_action_just_pressed("tire"):
		request_bullet.rpc()
	if Input.is_action_just_pressed("ui_select"):
		if $Timer.time_left == 0:
			Speed += 3000
			$Timer.start()
		

	move_and_slide()





@rpc("any_peer","call_local","reliable")
func request_bullet() -> void:
	if not multiplayer.is_server():
		return

	var insbullet = bullet.instantiate()
	insbullet.position = global_position
	get_parent().add_child(insbullet, true)


func _on_timer_timeout() -> void:
	if not is_multiplayer_authority():
		return
	Speed = 500.0

var tween : Tween
var time = 0.1
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("droite"):
		tween = create_tween()
		tween.tween_property(roue, "rotation_degrees", 90, time)
	if event.is_action_pressed("gauch"):
		tween = create_tween()
		tween.tween_property(roue, "rotation_degrees", -90, time)
	if event.is_action_pressed("bas"):
		tween = create_tween()
		tween.tween_property(roue, "rotation_degrees", 180, time)
	if event.is_action_pressed("haut"):
		tween = create_tween()
		tween.tween_property(roue, "rotation_degrees", 0, time)

func animation():
	if velocity == Vector2(0,0):
		roue.animation = "default"
	else:
		roue.animation = "move"
