extends RigidBody2D

@export var hp: float = 800.0                 # выше, чем у птицы, но всё ещё можно настроить
@export var damage_threshold: float = 5.0     # стекло более чувствительно
@export var fall_speed_threshold: float = 400.0
@export var fall_delta_threshold: float = 150.0
@export var fall_damage_multiplier: float = 1.2

@export var win_condition_speed: float = 300.0

@onready var collision: CollisionShape2D = $CollisionShape2D

signal glass_shattered()

var previous_velocity: Vector2 = Vector2.ZERO
var prev_colliders: Array = []
var shattered: bool = false

func _ready() -> void:
	contact_monitor = true

func _physics_process(delta: float) -> void:
	if shattered:
		return
	var current_colliders: Array = get_colliding_bodies()
	for body in current_colliders:
		if not prev_colliders.has(body):
			_process_initial_contact(body)
	prev_colliders = current_colliders.duplicate()
	previous_velocity = linear_velocity

func _process_initial_contact(body: Node) -> void:
	if shattered or body == null:
		return

	if body is RigidBody2D:
		var rb := body as RigidBody2D
		var rel_vel := rb.linear_velocity - linear_velocity
		var impact := rel_vel.length() * rb.mass
		if rb.linear_velocity.length() >= win_condition_speed:
			impact *= 1.3
		if impact > damage_threshold:
			_apply_damage(impact)
		return

	var delta_vy := previous_velocity.y - linear_velocity.y
	if previous_velocity.y > fall_speed_threshold and delta_vy > fall_delta_threshold:
		var fall_damage := delta_vy * mass * fall_damage_multiplier
		_apply_damage(fall_damage)

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if shattered or body == null:
		return
	if body is RigidBody2D:
		var rb := body as RigidBody2D
		var impact := rb.linear_velocity.length() * rb.mass
		if rb.linear_velocity.length() >= win_condition_speed:
			impact *= 1.2
		if impact > damage_threshold:
			_apply_damage(impact)

func _apply_damage(amount: float) -> void:
	if shattered or amount <= 0.0:
		return
	hp -= amount
	if hp <= 0.0:
		_shatter()

func _shatter() -> void:
	if shattered:
		return
	shattered = true
	if collision:
		collision.set_deferred("disabled", true)
	visible = false
	sleeping = true
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
