extends Node2D

const PLAYER_CONTROLLER = preload("uid://disid262nfj6n")

var players: Array[CharacterBody2D]

@export var chasseur :bool
@export var player_inst = 0

func _ready() -> void:
	$CanvasLayer.visible = true
	Networking.host_created.connect(on_host_created)


func on_host_created() -> void:
	# Spawn the server player
	spawn_player(multiplayer.get_unique_id())
	multiplayer.peer_connected.connect(spawn_player)


# The server spawns the player that just connected
func spawn_player(peer_id: int) -> void:
	var new_player := PLAYER_CONTROLLER.instantiate() as CharacterBody2D
	new_player.name = str(peer_id)
	add_child(new_player)
	initialize_player(new_player)
	if player_inst == 0:
		if chasseur == true:
			new_player.chasseur = true
		else:
			new_player.chasseur = false
	elif player_inst == 1:
		if chasseur == true:
			new_player.chasseur = false
		else:
			new_player.chasseur = true
	player_inst += 1


func initialize_player(player: CharacterBody2D) -> void:
	player.position = $SpawnPoint.position
	for other in players:
		player.add_collision_exception_with(other)
	players.append(player)
	
	if $CanvasLayer:
		$CanvasLayer.queue_free()

func _on_multiplayer_spawner_spawned(node: Node) -> void:
	if node is CharacterBody2D:
		initialize_player(node)


func _on_defendeur_pressed() -> void:
	chasseur = false
	Networking.host_lobby()
func _on_chasseur_pressed() -> void:
	chasseur = true
	Networking.host_lobby()
