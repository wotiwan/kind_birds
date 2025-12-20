extends Node2D

@onready var player = $BlueBird;
@onready var camera = $Camera2D;

@onready var lose_menu = $CanvasLayer/LoseMenu
@onready var win_menu = $CanvasLayer/WinMenu

var isCameraFixed: bool = true;

var birdsToThrow: int = 2  # Тут указываем кол-во птиц на сцене
var birdsThrown: int = 0  # Это не трогаем

var catsToDefeat: int = 1  # Тут указываем кол-во кошек на сцене
var catsDefeated: int = 0  # Это не трогаем
var empty_birds:bool = false
@export var death_signal_delay: float = 2.1 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sling = get_node("Slingshot")
	get_node("Level1/WhiteCat1").connect("bird_defeated", self._on_bird_defeated)
	sling.connect("bird_thrown", _on_bird_thrown) 
	sling.connect("bird_respawned", _on_bird_respawned)
	sling.connect("empty_birds",_empty_checked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if catsDefeated >= catsToDefeat:  # win condition
		win_menu.set_active()
	elif birdsThrown >= birdsToThrow and empty_birds:
		await get_tree().create_timer(death_signal_delay).timeout
		if catsDefeated >= catsToDefeat:
			win_menu.set_active()
		else:
			lose_menu.set_active()
		
	if !isCameraFixed:
		camera.set_position(player.get_position())
		#print(player.get_position())
	
func _on_bird_thrown() -> void:
	isCameraFixed = false

func _on_bird_defeated() -> void:
	catsDefeated += 1
	
func _on_bird_respawned(newBird: Node2D) -> void:
	birdsThrown += 1
	camera.set_position(Vector2(300, 830))
	player = newBird
	isCameraFixed = true
func _empty_checked():
	empty_birds = true
