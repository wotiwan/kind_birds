extends Node2D

@onready var player = $BlueBird;
@onready var camera = $Camera2D;

var isCameraFixed: bool = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sling = get_node("Slingshot")
	sling.connect("bird_thrown", _on_bird_thrown) 
	sling.connect("bird_respawned", _on_bird_respawned)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !isCameraFixed:
		camera.set_position(player.get_position())
		print(player.get_position())
	
func _on_bird_thrown() -> void:
	isCameraFixed = false

func _on_bird_respawned(newBird: Node2D) -> void:
	camera.set_position(Vector2(300, 830))
	player = newBird
	isCameraFixed = true
