extends Node


func _ready() -> void:
	get_node("MainMenu/Margin/VB/NewGame").pressed.connect(on_new_game);
	get_node("MainMenu/Margin/VB/Exit").pressed.connect(on_exit);
	
	
func on_new_game():
	get_node("MainMenu").queue_free();
	var game_scene = load("res://Scenes/Core/game_scene.tscn").instantiate()
	add_child(game_scene);
	pass;
	
func on_exit():
	print("Sair")
	get_tree().quit();
