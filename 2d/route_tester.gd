extends Node2D


@onready var link := $"NavigationLink2D" as NavigationLink2D;
@onready var start := $"Start" as Node2D;
@onready var route_vis := $"RouteVis" as Line2D;
@onready var optimize_path_control := $VBoxContainer/OptimizePathButton as CheckButton;
@onready var enable_link_control := $VBoxContainer/EnableLinkButton as CheckButton;


func _ready() -> void:
	link.enabled = enable_link_control.button_pressed;


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var nav_map_rid := get_world_2d().navigation_map;
		var start_position := NavigationServer2D.map_get_closest_point(nav_map_rid, start.global_position);
		var target_position := NavigationServer2D.map_get_closest_point(nav_map_rid, event.position);
		var path := NavigationServer2D.map_get_path(nav_map_rid, start_position, target_position, optimize_path_control.button_pressed);
		
		route_vis.points = path;


func _on_enable_link_button_pressed() -> void:
	link.enabled = enable_link_control.button_pressed;
