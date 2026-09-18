extends Node2D
@onready var shop_container: GridContainer = $ShopContainer

var is_in_area
@export var chasseur_shop = false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if is_in_area:
		if Input.is_action_just_pressed("interact"):
			print("shop")
			if shop_container.visible == true:
				shop_container.visible = false
			else:
				shop_container.visible = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "chasseur" and chasseur_shop == true:
		print("shop ouvert")
		is_in_area = true
	if area.get_parent().name == "defender" and chasseur_shop == false:
		is_in_area = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	prints(area.get_parent().name)
	if area.get_parent().name == "chasseur" and chasseur_shop == true:
		print("shop ferme")
		is_in_area = false
		shop_container.visible = false
	if area.get_parent().name == "defender" and chasseur_shop == false:
		is_in_area = false
		shop_container.visible = false
