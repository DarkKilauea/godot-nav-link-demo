extends Node2D


@onready var nav_agent: NavigationAgent2D = $"NavigationAgent2D";
@onready var path_vis: Line2D = $"Line2D";

var initial_transform: Transform2D;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path_vis.top_level = true;
	path_vis.global_transform = Transform2D();
	
	initial_transform = self.global_transform;
	nav_agent.set_target_location(initial_transform.origin);


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var nav_map_rid := get_world_2d().navigation_map;
		var target_location := NavigationServer2D.map_get_closest_point(nav_map_rid, event.position);
		nav_agent.set_target_location(target_location);
	
	if event.is_action("reset"):
		nav_agent.set_target_location(initial_transform.origin);
		self.global_transform = initial_transform;


func _physics_process(delta: float) -> void:
	if !nav_agent.is_navigation_finished():
		var target := nav_agent.get_next_location();
		var current_pos := self.global_position;
		
		var direction := current_pos.direction_to(target);
		var velocity := direction * nav_agent.max_speed * delta;
		self.translate(velocity);


func draw_path() -> void:
	var path := nav_agent.get_nav_path();
	
	if !nav_agent.is_navigation_finished() and !path.is_empty():
		path_vis.points = path;
	else:
		path_vis.clear_points();


func _on_navigation_finished() -> void:
	print("Nav Finished!");
	draw_path();


func _on_target_reached() -> void:
	print("Target Reached!");
	draw_path();


func _on_path_changed() -> void:
	draw_path();
