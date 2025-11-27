extends Node2D

@onready var player = $BlueBird;
@onready var camera = $Camera2D;

var isCameraFixed: bool = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# camera setting
	if !isCameraFixed:
		camera.set_position(player.get_position())
	

func throwBird() -> void:
	isCameraFixed = true
