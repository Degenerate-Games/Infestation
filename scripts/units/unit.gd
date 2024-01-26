extends CharacterBody2D

class_name Unit

const SPEED = 300.0
var target: Node2D
var moving: bool = false
var attack
var defense
@export var spawn_timer: Timer
@export var health_bar: Control

func _physics_process(delta):
	if moving:
		velocity = pick_direction() * SPEED
		var old_rot = rotation
		rotation = rotate_toward(rotation, velocity.angle(), delta)
		move_and_slide()
		health_bar.rotation -= rotation - old_rot

func pick_direction():
	var random_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	if target:
		var target_direction = target.global_position - global_position
		random_direction = random_direction.lerp(target_direction.normalized(), 0.5)
	return random_direction

func delayed_spawn(delay, trgt = null):
	spawn_timer.start(delay)
	await spawn_timer.timeout
	position = Vector2.ZERO
	if trgt == null:
		target = Global.get_random_target()
	else:
		target = trgt	
	reparent(Global.current_level.get_node("Spawner"), false)
	moving = true

func take_damage(damage):
	if health_bar.take_damage(damage):
		queue_free()
