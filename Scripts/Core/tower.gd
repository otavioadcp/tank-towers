class_name TowerBase

extends Node2D




func _init():
	pass
	
func _physics_process(_delta: float) -> void:
	turn_tower();
	
func _process(delta: float) -> void:
	pass;
	
	
func turn_tower():
	var enemy_position = get_global_mouse_position();
	get_node("Turret").look_at(enemy_position);
