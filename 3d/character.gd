extends CharacterBody3D


@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D;
@onready var camera: Camera3D = $Camera3D;
@onready var path_vis: MeshInstance3D = $PathVisualization;


var initial_transform: Transform3D;
var nav_path_mesh := ImmediateMesh.new();


func _ready() -> void:
	path_vis.mesh = nav_path_mesh;
	path_vis.top_level = true;
	path_vis.global_transform = Transform3D();
	
	initial_transform = self.global_transform;
	nav_agent.target_position = initial_transform.origin;


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var from := camera.project_ray_origin(event.position)
		var to := from + camera.project_ray_normal(event.position) * camera.far;
		
		var nav_map_rid := get_world_3d().navigation_map;
		var target_position := NavigationServer3D.map_get_closest_point_to_segment(nav_map_rid, from, to);
		nav_agent.target_position = target_position;
	
	if event.is_action("reset"):
		nav_agent.target_position = initial_transform.origin;
		self.global_transform = initial_transform;


func _physics_process(delta: float) -> void:
	# Reset velocity
	velocity = Vector3();
	
	# Add gravity
	velocity += Vector3.UP * -9.8;
	
	# Add movement along path
	if !nav_agent.is_navigation_finished():
		var target := nav_agent.get_next_path_position();
		target.y = 0;
		
		var current_pos := get_global_transform().origin;
		current_pos.y = 0;
		
		var direction := current_pos.direction_to(target);
		var desired_velocity := direction * nav_agent.max_speed;
		
		velocity += desired_velocity;
	
	move_and_slide();


func draw_path() -> void:
	var path := nav_agent.get_current_navigation_path();
	nav_path_mesh.clear_surfaces();
	
	if !nav_agent.is_navigation_finished() and !path.is_empty():
		nav_path_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP);
		
		for point in path:
			nav_path_mesh.surface_add_vertex(point);
		
		nav_path_mesh.surface_end();


func _on_navigation_finished() -> void:
	print("Nav Finished!");
	draw_path();


func _on_target_reached() -> void:
	print("Target Reached!");
	draw_path();


func _on_path_changed() -> void:
	draw_path();


func _on_link_reached(details: Dictionary) -> void:
	print("Link reached: %s" % details);


func _on_waypoint_reached(details: Dictionary) -> void:
	print("Waypoint reached: %s" % details);
