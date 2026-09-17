extends Node2D
@onready var shop_container: GridContainer = $ShopContainer

var is_in_area
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_in_area:
		if Input.is_action_just_pressed("interact"):
			print("shop")
			if shop_container.visible == true:
				shop_container.visible = false
			else:
				shop_container.visible = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "1":
		print("shop ouvert")
		is_in_area = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	prints(area.get_parent().name)
	if area.get_parent().name == "1":
		if shop_container.visible == true:
			shop_container.visible = false
		print("shop ferme")
		is_in_area = false
