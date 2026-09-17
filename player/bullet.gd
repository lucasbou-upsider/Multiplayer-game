extends Node2D

var healt: int = 100
var direction 

func _ready() -> void:
	look_at(get_global_mouse_position()) 
	direction = get_global_mouse_position()



func _process(delta: float) -> void:
	position += transform.x * 40


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "1" or area.get_parent().name == "2":
		area.get_parent().healt -= 10 


func _on_timer_timeout() -> void:
	queue_free()
