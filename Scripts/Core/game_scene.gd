extends Node2D

#Mapa sendo jogado
var map_node;

var build_mode = false;
var build_valid = false;

#Localizaçao do tile que estão em interação
var build_tile;
var build_location;

#Tipo da torre a ser construída
var build_type;

var current_wave = 0;
var enemies_in_wave = 0;


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
	

######
# Building Functions
#####

func init_build_mode(tower_type: String):
	if build_mode:
		cancel_build_mode();
	
	build_type = tower_type.to_lower() + "_lvl_1";
	build_mode = true;
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position());
	print("chamado => ", tower_type)
	pass;

func cancel_build_mode():
	build_mode = false;
	build_valid = false;
	
	#Não pode usar o "queue_free", pois estamos criando um novo "preview" no mesmo frame que excluimos
	#Entao o novo teria um Id 2, causando erro de "Nao encontrado" 
	#Por isso, excluimos imediatamente, para o novo manter Id 1
	get_node("UI/TowerPreview").free();

func verify_and_build():
	if build_valid:
		#Checar se tem dinheiro
		var new_tower = load("res://Scenes/Towers/" + build_type + ".tscn").instantiate();
		new_tower.position = build_location;
		new_tower.is_built = true;
		new_tower.tower_type = build_type;
		
		map_node.get_node("Towers").add_child(new_tower, true);
		#Coloca tile transparente no mesmo lugar da torre
		#Para bloquear construir 2 no mesmo lugar
		block_tile_from_build(build_tile);
		
		#debitar dinheiro
		#atualizar UI
		
func block_tile_from_build(tile_position: Vector2i) -> void:
	map_node.get_node("TowerExclusion").set_cell(tile_position, 5, Vector2i(0, 0))

func update_tower_preview():
	var mouse_position = get_global_mouse_position();
	var current_tile = map_node.get_node("TowerExclusion").local_to_map(mouse_position);
	var tile_position = map_node.get_node("TowerExclusion").map_to_local(current_tile);
	
	if map_node.get_node("TowerExclusion").get_cell_source_id(current_tile) == -1:
		get_node("UI").update_tower_preview(tile_position, "3caa45")
		build_valid = true;
		build_location = tile_position;
		build_tile = current_tile
	else:
		get_node("UI").update_tower_preview(tile_position, "c60000");
		build_valid = false;


#######
# Wave
#######

func start_wave():
	var wave_data = retrieve_wave_data();
	await get_tree().create_timer(0.2).timeout;
	spawn_enemies(wave_data);
	
func retrieve_wave_data():
	var wave_data = [["green_tank", 0.7], ["green_tank", 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size();
	return wave_data;
	
func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate();
		map_node.get_node("Path2D").add_child(new_enemy, true);
		await get_tree().create_timer(i[1]).timeout;
		 



######
# Game Controls
######
