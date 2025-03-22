extends Node2D

var map_node;

var build_mode = false;
var build_valid = false;
var build_location;
var build_type;


func _ready():
	map_node = get_node("Map 1")
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(init_build_mode.bind(i.name))
	

func _process(_delta: float) -> void:
	if build_mode:
		update_tower_preview();


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode();
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build();
		cancel_build_mode();
	

func init_build_mode(tower_type: String):
	build_type = tower_type.to_lower() + "_lvl_1";
	build_mode = true;
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position());
	print("chamado => ", tower_type)
	pass;

func cancel_build_mode():
	build_mode = false;
	build_valid = false;
	get_node("UI/TowerPreview").queue_free();

func verify_and_build():
	if build_valid:
		#Checar se tem dinheiro
		var new_tower = load("res://Scenes/Towers/" + build_type + ".tscn").instantiate();
		new_tower.position = build_location;
		map_node.get_node("Towers").add_child(new_tower, true);
		#debitar dinheiro
		#atualizar UI

func update_tower_preview():
	var mouse_position = get_global_mouse_position();
	var current_tile = map_node.get_node("TowerExclusion").local_to_map(mouse_position);
	var tile_position = map_node.get_node("TowerExclusion").map_to_local(current_tile);
	
	if map_node.get_node("TowerExclusion").get_cell_source_id(current_tile) == -1:
		get_node("UI").update_tower_preview(tile_position, "3caa45")
		build_valid = true;
		build_location = tile_position;
	else:
		get_node("UI").update_tower_preview(tile_position, "c60000");
		build_valid = false;


 
