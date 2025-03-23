class_name TowerBase

extends Node2D

var tower_type: String;
var enemies_array = [];
var is_built = false;
var enemy; 
func _ready():
	if is_built:
		var tower_data = GameData.towers_data.get(tower_type);
		self.get_node("Range/CollisionShape2D").shape.radius = 0.5 * tower_data.get("range");


func _init():
	pass
	
func _physics_process(_delta: float) -> void:
	if enemies_array.size() != 0 and is_built:
		select_enemy();
		turn_tower();
	else: 
		enemy = null;
	
func _process(delta: float) -> void:
	pass;
	
func select_enemy():
	var enemy_progress_array = [];
	
	for i in enemies_array:
		enemy_progress_array.append(i.progress);
	var max_progress = enemy_progress_array.max();
	var enemy_index = enemy_progress_array.find(max_progress);
	enemy = enemies_array[enemy_index];
	
func turn_tower():
	get_node("Turret").look_at(enemy.position);
	
func _on_range_body_entered(body: Node2D) -> void:
	enemies_array.append(body.get_parent())
	print("Inimigo entrou: ", enemies_array)


func _on_range_body_exited(body: Node2D) -> void:
	enemies_array.erase(body.get_parent())
	print("Inimigo saiu: ", enemies_array)
