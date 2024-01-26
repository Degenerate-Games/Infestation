extends CharacterBody2D


const SPEED = 300.0

enum MODE {ATTACK, REPAIR}

var target: Node2D = null
var current_mode = MODE.REPAIR
var attack = 4
@export var health_bar: Control

func _process(_delta):
	match current_mode:
		MODE.ATTACK:
			if not valid_target():
				target = Global.get_random_target(false, false, true)
				$AttackTimer.start(2)
		MODE.REPAIR:
			$AttackTimer.stop()
			if not valid_target():
				target = Global.get_random_target(true, false, false)
			if target.health_bar.is_below_half():
				current_mode = MODE.ATTACK
				target = Global.get_random_target(false, false, false)

func valid_target():
	return target != null and target.is_inside_tree()

func _physics_process(delta):
	if valid_target():
		var target_direction = target.global_position - global_position
		target_direction = target_direction.normalized()
		velocity = target_direction * SPEED
	else:
		velocity = velocity.lerp(Vector2.ZERO, delta)
	move_and_slide()

func attack_target():
	if valid_target() and in_range(target) and target.has_method("take_damage"):
		target.take_damage(attack)

func in_range(trgt):
	print(trgt.global_position.distance_to(global_position))
	return trgt.global_position.distance_to(global_position) < 100.0

func take_damage(damage):
	if health_bar.take_damage(damage):
		queue_free()
