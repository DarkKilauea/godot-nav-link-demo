extends Node2D


const Agent: PackedScene = preload("res://2d/agent.tscn");


@export var max_agents := 10_000;
@export var agents_per_tick := 1;

var current_agents := 0;


func _ready() -> void:
	randomize();


func _on_spawn_timer_timeout() -> void:
	var spawn_points: Array[Node2D] = get_tree().get_nodes_in_group("spawners");
	
	for i in agents_per_tick:
		if current_agents >= max_agents:
			return;
		
		var random_spawn_idx = randi_range(0, spawn_points.size() - 1);
		
		var chosen_point := spawn_points[random_spawn_idx];
		var agent := Agent.instantiate();
		agent.position = chosen_point.position;
		add_child(agent);
		
		current_agents += 1;
