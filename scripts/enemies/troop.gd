extends CharacterBody2D


const SPEED = 300.0

enum MODE {ATTACK, REPAIR}

var target: Node2D = null
var current_mode = MODE.REPAIR
var attack = 4
@export var health_bar: Control

func _ready():
	$AttackTimer.start(2)

func _process(_delta):
	match current_mode:
		MODE.ATTACK:
			if not valid_target():
				target = Global.get_random_target(false, false, true)
		MODE.REPAIR:
			if not valid_target():
				target = Global.get_random_target(true, false, false)
			if target.health_bar.is_below_half():
				current_mode = MODE.ATTACK
				target = Global.get_random_target(false, false, false)

func enter_repair_mode():
	current_mode = MODE.REPAIR
	target = null

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
		match current_mode:
			MODE.ATTACK:
				target.take_damage(attack)
			MODE.REPAIR:
				target.take_damage(-attack)

func in_range(trgt):
	return trgt.global_position.distance_to(global_position) < 100.0

func take_damage(damage):
	if health_bar.take_damage(damage):
		current_mode = MODE.ATTACK
		Global.HUD.increase_score(900)
		queue_free()
