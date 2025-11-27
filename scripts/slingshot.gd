extends Node2D

signal bird_thrown() # Для управления в скрипте сцены
signal bird_respawned(Node2D)

enum SlingState {
	IDLE, 
	PULLING, # Режим прицеливания, растягивания резинки
	THROWN, # Момент от запуска птицы до её исчезновения (столкновения)
	RESET # Замена птицы на новую, после переход в IDLE
}

var slingState: SlingState;

## Макисмальный радиус растягивания резинки
const PULL_RADIUS: int = 200;
## Константа, определяющая силу броска птички
const THROW_FORCE: int = 7;

## Где будет находиться резинка в состоянии IDLE
var slingIdlePosition: Vector2 = Vector2(15, -158);

@onready var hitBox = $StaticBody2D/HitBox/HitBoxArea;
@onready var leftLine = $leftLine;
@onready var rightLine = $rightLine;

## Птица в начале уровня, поменять при необходимости
var startBird: String = "BlueBird";
## Следующие птицы загружаются на сцену динамически
var secondBird: String = "green_bird_1";

@onready var currentBird = get_tree().current_scene.get_node(startBird)

func _ready() -> void:
	currentBird.set_freeze_enabled(1)
	slingState = SlingState.IDLE
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match slingState:
		SlingState.IDLE:
			pass
		SlingState.PULLING:
			if Input.is_action_pressed("left_mouse_button_click"):
				
				var mousePosition = get_global_mouse_position()
				## Ограничиваем растягивание резинки
				if mousePosition.distance_to(hitBox.global_position) > PULL_RADIUS:
					mousePosition = (mousePosition - hitBox.global_position).normalized() * PULL_RADIUS + hitBox.global_position
				currentBird.position = mousePosition
				mousePosition = to_local(mousePosition)
				leftLine.points[0] = mousePosition
				rightLine.points[0] = mousePosition
			else:
				## Происходит когда игрок отпускает ЛКМ
				currentBird.set_freeze_enabled(0)
				var mousePosition = get_global_mouse_position()
				if mousePosition.distance_to(hitBox.global_position) > PULL_RADIUS:
					mousePosition = (mousePosition - hitBox.global_position).normalized() * PULL_RADIUS + hitBox.global_position
				var velocity = hitBox.global_position - mousePosition
				currentBird = currentBird as RigidBody2D
				currentBird.apply_impulse(velocity * THROW_FORCE, mousePosition)
				slingState = SlingState.THROWN
		SlingState.THROWN:
			bird_thrown.emit()
			leftLine.points[0] = slingIdlePosition
			rightLine.points[0] = slingIdlePosition
		SlingState.RESET:
			slingState = SlingState.IDLE
			# Убираем текущую птицу
			currentBird.set_freeze_enabled(1)
			currentBird.get_child(1).disabled = true # Обращаем к колижен шейп по индексу
			currentBird.visible = false
			await get_tree().create_timer(2.0).timeout
			# Создаём новую птицу и перемещаем на позицию рогатки
			currentBird = get_tree().current_scene.get_node(secondBird)
			currentBird.visible = true
			currentBird.position = Vector2(352, 779)
			# Передаём в main инфо о том, что новая птица создана
			bird_respawned.emit(currentBird)
	

func _on_hit_box_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_mouse_button_click"):
		print("LKM!")
		slingState = SlingState.PULLING

func _on_blue_bird_body_entered(body: Node) -> void:
	slingState = SlingState.RESET

func _on_green_bird_1_body_entered(body: Node) -> void:
	slingState = SlingState.RESET
