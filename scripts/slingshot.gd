extends Node2D

enum SlingState {
	IDLE,
	PULLING,
	THROWN,
	RESET
}

var slingState: SlingState;

## Макисмальный радиус растягивания резинки
const PULL_RADIUS: int = 200;

## Где будет находиться резинка в состоянии IDLE
var slingIdlePosition: Vector2 = Vector2(15, -158);

@onready var hitBox = $StaticBody2D/HitBox/HitBoxArea;
@onready var leftLine = $leftLine;
@onready var rightLine = $rightLine;

func _ready() -> void:
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
				
				mousePosition = to_local(mousePosition)
				print(mousePosition)
				leftLine.points[0] = mousePosition
				rightLine.points[0] = mousePosition
			else:
				## Происходит когда игрок отпускает ЛКМ
				slingState = SlingState.THROWN
		SlingState.THROWN:
			leftLine.points[0] = slingIdlePosition
			rightLine.points[0] = slingIdlePosition
			slingState = SlingState.IDLE
			## TODO: Добавить бросок самой птицы
		SlingState.RESET:
			pass
	

func _on_hit_box_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_mouse_button_click"):
		slingState = SlingState.PULLING
	
