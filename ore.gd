extends Node2D

var healt = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "pioche":
		healt -= 1
		$ColorRect.modulate = Color(1.0, 0.282, 1.0)
		if healt == 0:
			queue_free()
	print(area.name)



func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "pioche":
		$ColorRect.modulate = Color(1.0, 1.0, 1.0, 1.0)
