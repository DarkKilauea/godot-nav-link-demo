extends Node2D


const Agent: PackedScene = preload("res://2d/agent.tscn");


@export var max_agents := 10_000;
@export var agents_per_tick := 1;

@onready var agent_count_label: Label = $AgentCountLabel;
@onready var navigation_link: NavigationLink2D = $NavigationLink2D
@onready var teleporter: Area2D = $Platform1/Teleporter
@onready var teleporter_2: Area2D = $Platform2/Teleporter2

var current_agents := 0;


func _ready() -> void:
	randomize();


func _physics_process(delta: float) -> void:
	navigation_link.start_position = teleporter.global_position * navigation_link.transform;
	navigation_link.end_position = teleporter_2.global_position * navigation_link.transform;


func _on_spawn_timer_timeout() -> void:
	var spawn_points: Array[Node] = get_tree().get_nodes_in_group("spawners");
	
	for i in agents_per_tick:
		if current_agents >= max_agents:
			break;
		
		var random_spawn_idx = randi_range(0, spawn_points.size() - 1);
		
		var chosen_point := spawn_points[random_spawn_idx];
		var agent := Agent.instantiate();
		add_child(agent);
		agent.global_position = chosen_point.global_position;
		
		current_agents += 1;
	
	agent_count_label.text = str(current_agents);
