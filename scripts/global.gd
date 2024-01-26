extends Node2D

var selected_card
var current_level: Node2D:
	get:
		return get_node_or_null("/root/Level")
var HUD: Node2D:
	get:
		return get_node_or_null("/root/Level/HUD")

func lerpvec2(from: Vector2, to: Vector2, weight: float):
	var temp = Vector2.ZERO
	temp.x = lerpf(from.x, to.x, weight)
	temp.y = lerpf(from.y, to.y, weight)
	return temp

func get_random_target():
	var targets = current_level.get_node("Enemies/Structures").get_children()
	targets.append_array(current_level.get_node("Enemies/Troops").get_children())
	if targets.size() == 0:
		return null
	var target = targets[randi() % targets.size()]
	return target

func get_physics_node_under_mouse():
	var mouse_position = get_viewport().get_mouse_position()
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_position
	query.collision_mask = Global.get_layer_mask([2,3])
	var result = space_state.intersect_point(query)
	if result:
			return result[0]["collider"]
	return null

func get_layer_mask(layers):
	var mask = 0
	for layer in layers:
		mask += pow(2, layer - 1)
	return mask

func _unhandled_input(event):
	if event.is_action_pressed("Select"):
		print("Select")
		if selected_card:
			print(selected_card)
			if selected_card.play_actions.has("manual_target"):
				print("manual_target")
				var node = get_physics_node_under_mouse()
				if node != null:
					selected_card.play_actions["manual_target"] = node
					selected_card.selected = false
					selected_card.play_card()
					HUD.discard_card(selected_card)
					selected_card = null
