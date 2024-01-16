extends Node

var selected_card
var HUD: Node2D:
	get:
		return get_node_or_null("/root/Level/HUD")

func lerpvec2(from: Vector2, to: Vector2, weight: float):
	var temp = Vector2.ZERO
	temp.x = lerpf(from.x, to.x, weight)
	temp.y = lerpf(from.y, to.y, weight)
	return temp
