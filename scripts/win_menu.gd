extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_active() -> void:
	visible = true


func _on_exit_button_button_down() -> void:
	get_tree().paused = false # На случай если пользователь жмал esc и поставил паузу
	get_tree().change_scene_to_file("res://scenes/UI/levels_menu.tscn")


func _on_next_lvl_button_button_down() -> void:
	get_tree().paused = false # На случай если пользователь жмал esc и поставил паузу
	# Название следующего уровня
	get_tree().change_scene_to_file("res://scenes/second_scene.tscn")
