extends CharacterBody2D

class_name Unit

const SPEED = 300.0
var target: Node2D
var paused: bool = false
var attack
var defense

func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	pass

func _physics_process(delta):
	if paused: return
	velocity = pick_direction() * SPEED
	print(velocity)
	move_and_slide()

func pick_direction():
	var random_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	if target:
		random_direction = random_direction.dot(target.position)
	return random_direction
