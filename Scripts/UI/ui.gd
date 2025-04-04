extends CanvasLayer


func set_tower_preview(tower_type, mouse_position):
	var drag_tower = load("res://Scenes/Towers/" + tower_type + ".tscn").instantiate();
	drag_tower.set_name("DragTower");
	drag_tower.modulate = Color("3caa45"); #verde
	
	var tower_data = GameData.towers_data.get(tower_type);
	
	var range_indicator = create_range_indicator(tower_data.get("range"));
	
	var control = Control.new();
	control.add_child(drag_tower, true);
	control.add_child(range_indicator, true);
	
	control.global_position  = mouse_position;
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"),0)
	
	
func update_tower_preview(new_position, color):
	get_node("TowerPreview").position = new_position;
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color);
		get_node("TowerPreview/Sprite2D").modulate = Color(color);

func create_range_indicator(tower_range: float) -> Sprite2D:
	var range_texture = Sprite2D.new();
	range_texture.position = Vector2(0,0);
	
	var scaling = tower_range / 600.0;
	range_texture.scale = Vector2(scaling, scaling);
	
	var texture = load("res://Assets/Environment/Tileset/range_overlay.png")
	range_texture.texture = texture;
	range_texture.modulate = Color("3caa45");
	
	return range_texture;


func _on_play_pause_pressed() -> void:
	var scene_tree: SceneTree = get_tree();
	var game_scene: Node2D = get_parent();
	
	if game_scene.build_mode:
		game_scene.cancel_build_mode();
	
	if scene_tree.paused:
		scene_tree.paused = false;
	elif game_scene.current_wave == 0:
		game_scene.current_wave += 1;
		game_scene.start_wave();
	else:
		scene_tree.paused = true;


func _on_fast_foward_pressed() -> void:
	if Engine.time_scale == 1.0:
		Engine.time_scale = 2.0;
	else:
		Engine.time_scale = 1.0
