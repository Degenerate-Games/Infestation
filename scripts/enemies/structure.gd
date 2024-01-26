extends StaticBody2D

@export var health_bar: Control

func take_damage(damage):
		if health_bar.take_damage(damage):
			queue_free()
