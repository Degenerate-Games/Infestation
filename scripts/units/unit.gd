extends CharacterBody2D

class_name Unit

const SPEED = 300.0
var target: Node2D
var moving: bool = false
var attack
var defense
@export var spawn_timer: Timer

func _physics_process(_delta):
	if moving:
		velocity = pick_direction() * SPEED
		# print(velocity)
		move_and_slide()

func pick_direction():
	var random_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	if target:
		random_direction = random_direction.dot(target.position)
	return random_direction

func delayed_spawn(delay):
	spawn_timer.start(delay)
	await spawn_timer.timeout
	# TODO:: Teleport to spawn point
	moving = true
