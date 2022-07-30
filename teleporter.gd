extends Area3D


@export_node_path(Node3D) var destination: NodePath;


func _on_body_entered(body: Node3D) -> void:
	if !body || body.is_in_group("teleporting"):
		return;
	
	var destination_node: Node3D = get_node(destination);
	var direction := destination_node.global_position - self.global_position;
	
	body.add_to_group("teleporting");
	body.translate(direction);


func _on_body_exited(body: Node3D) -> void:
	if !body || !body.is_in_group("teleporting"):
		return;
	
	body.remove_from_group("teleporting");
