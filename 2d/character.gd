extends CharacterBody2D


@onready var nav_agent: NavigationAgent2D = $"NavigationAgent2D";

var initial_transform: Transform2D;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_transform = self.global_transform;
	nav_agent.target_position = initial_transform.origin;


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var nav_map_rid := get_world_2d().navigation_map;
		var target_position := NavigationServer2D.map_get_closest_point(nav_map_rid, event.position);
		nav_agent.target_position = target_position;
	
	if event.is_action("reset"):
		nav_agent.target_position = initial_transform.origin;
		self.global_transform = initial_transform;


func _physics_process(delta: float) -> void:
	if !nav_agent.is_navigation_finished():
		var target := nav_agent.get_next_path_position();
		var current_pos := self.global_position;
		
		var direction := current_pos.direction_to(target);
		velocity = direction * nav_agent.max_speed;
		nav_agent.set_velocity(velocity);
		
		move_and_slide();


func _on_navigation_finished() -> void:
	print("Nav Finished!");


func _on_target_reached() -> void:
	print("Target Reached!");


func _on_path_changed() -> void:
	pass;


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	print("Safe Velocity: %s" % safe_velocity);
