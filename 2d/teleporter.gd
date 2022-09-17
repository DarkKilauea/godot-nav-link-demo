extends Area2D


@export_node_path(Node2D) var destination: NodePath;


func _on_body_entered(body: Node2D) -> void:
	if !body || body.is_in_group("teleporting"):
		return;
	
	var destination_node: Node2D = get_node(destination);
	var direction := destination_node.global_position - self.global_position;
	
	body.add_to_group("teleporting");
	body.translate(direction);


func _on_body_exited(body: Node2D) -> void:
	if !body || !body.is_in_group("teleporting"):
		return;
	
	body.remove_from_group("teleporting");
