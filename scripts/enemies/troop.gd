extends CharacterBody2D


const SPEED = 300.0

@export var health_bar: Control

func _physics_process(_delta):
	move_and_slide()

func take_damage(damage):
	if health_bar.take_damage(damage):
		queue_free()
