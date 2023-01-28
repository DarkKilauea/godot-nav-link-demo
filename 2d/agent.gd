extends CharacterBody2D

const WORLD_WIDTH := 1024.0;
const WORLD_HEIGHT := 600.0;


@onready var nav_agent: NavigationAgent2D = $"NavigationAgent2D";

var nav_map_rid: RID;


func _ready() -> void:
	nav_map_rid = get_world_2d().navigation_map;
	_move_to_random_position();


func _physics_process(delta: float) -> void:
	if !nav_agent.is_navigation_finished():
		var target := nav_agent.get_next_path_position();
		var current_pos := self.global_position;
		
		var direction := current_pos.direction_to(target);
		velocity = direction * nav_agent.max_speed;
		move_and_slide();
	else:
		_move_to_random_position();


func _move_to_random_position() -> void:
	var random_position := Vector2(randf_range(0.0, WORLD_WIDTH), randf_range(0.0, WORLD_HEIGHT));
	var target_position := NavigationServer2D.map_get_closest_point(nav_map_rid, random_position);
	nav_agent.target_position = target_position;
