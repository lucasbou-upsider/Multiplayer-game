extends CharacterBody2D

@onready var roue: AnimatedSprite2D = $Roue
@export var healt := 100.0
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var tete: AnimatedSprite2D = $Tete
var bullet = preload("res://player/bullet.tscn")
var Speed := 500.0
var accelariation = 2000
var friction = 1000
var wheel_turn_speed = 10
var target_zoom: Vector2 = Vector2.ONE
var target_pos: Vector2

@export_category("dash parametre")
@export var dash:bool
@export var dash_time = 0.2
@export var dash_pos:Vector2

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

	animation()
	progress_bar.value = healt
	
	tete.look_at(get_global_mouse_position()) 
	#tete.rotation += 89.6
	
	var input_dir = Input.get_vector("gauch", "droite", "haut", "bas")
	if input_dir != Vector2.ZERO:
		velocity =  velocity.move_toward(input_dir * Speed, accelariation * delta)
	else:
		velocity =  velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if input_dir != Vector2.ZERO:
		var target_angle = input_dir.angle()
		roue.rotation = lerp_angle(roue.rotation, target_angle, wheel_turn_speed * delta)
	position = position.lerp(target_pos,10 * delta)
	if !dash:
		target_pos = position
	else:
		target_pos = dash_pos

	if Input.is_action_just_pressed("tire"):
		request_bullet.rpc()
	if Input.is_action_just_pressed("ui_select"):
		if $Timer.time_left == 0:
			dash = true
			dash_pos = $Tete/RayCast2D.to_global($Tete/RayCast2D.target_position)
			await get_tree().create_timer(dash_time).timeout
			dash = false
			$Timer.start()
		
	if Input.is_action_just_pressed("dezoom"):
		$Camera2D.zoom = lerp($Camera2D.zoom , $Camera2D.zoom + Vector2(0.05, 0.05), 1000 * delta )
	
	#$Camera2D.zoom = $Camera2D.zoom.lerp(target_zoom, 10.0 * delta)

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
	if not is_multiplayer_authority():
		return
	#if event.is_action_pressed("dezoom"):
		#target_zoom -= Vector2(0.05, 0.05)
	#elif event.is_action_pressed("zoom"):
		#target_zoom += Vector2(0.05, 0.05)
	#target_zoom.x = clamp(target_zoom.x, 0.1, 1)
	#target_zoom.y = clamp(target_zoom.y, 0.1, 1)
	
	
	
	
	#if event.is_action_pressed("droite"):
		#tween = create_tween()
		#tween.tween_property(roue, "rotation_degrees", 90, time)
	#if event.is_action_pressed("gauch"):
		#tween = create_tween()
		#tween.tween_property(roue, "rotation_degrees", -90, time)
	#if event.is_action_pressed("bas"):
		#tween = create_tween()
		#tween.tween_property(roue, "rotation_degrees", 180, time)
	#if event.is_action_pressed("haut"):
		#tween = create_tween()
		#tween.tween_property(roue, "rotation_degrees", 0, time)

func animation():
	if velocity == Vector2(0,0):
		roue.animation = "default"
	else:
		roue.animation = "move"
		
