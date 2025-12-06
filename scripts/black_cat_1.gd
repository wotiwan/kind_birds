extends RigidBody2D

const winConditionSpeed: float = 300.0
signal bird_defeated()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body is RigidBody2D:
		var rb := body as RigidBody2D
		var speed = rb.linear_velocity.length()
		if speed >= winConditionSpeed:
			print("Кошка побеждена!")
			emit_signal("bird_defeated")
			queue_free()
