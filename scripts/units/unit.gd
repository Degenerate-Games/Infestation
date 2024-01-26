extends CharacterBody2D

class_name Unit

const SPEED = 300.0
var target: Node2D
var moving: bool = false:
	get:
		return moving
	set(value):
		moving = value
		if value:
			if animated_sprite: animated_sprite.play("default")
			$AttackTimer.start(1.0)
		else:
			if animated_sprite: animated_sprite.play("idle")
			$AttackTimer.stop()
var attack
var defense
@export var spawn_timer: Timer
@export var health_bar: Control
@export var animated_sprite: AnimatedSprite2D

func _physics_process(delta):
	if moving:
		velocity = pick_direction() * SPEED
		var old_rot = rotation
		rotation = rotate_toward(rotation, velocity.angle(), delta)
		move_and_slide()
		health_bar.rotation -= rotation - old_rot

func pick_direction():
	var random_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	if valid_target():
		var target_direction = target.global_position - global_position
		random_direction = random_direction.lerp(target_direction.normalized(), 0.5)
	else:
		target = Global.get_random_target()
		if target:
			random_direction = pick_direction()
		else:
			target = Global.current_level.get_node("Spawner")
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

func attack_target():
	if valid_target() and in_range(target) and target.has_method("take_damage"):
		target.take_damage(attack)

func in_range(trgt):
	return trgt.global_position.distance_to(global_position) < 100.0

func valid_target():
	return target != null and target.is_inside_tree()

func take_damage(damage):
	damage = (damage / defense) * 1.5
	damage = floor(damage)
	if health_bar.take_damage(damage):
		queue_free()
