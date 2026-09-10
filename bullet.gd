extends Node2D

var healt: int = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += 10


func _on_area_2d_area_entered(area: Area2D) -> void:
	area.get_parent().healt -= 10 


func _on_timer_timeout() -> void:
	queue_free()
