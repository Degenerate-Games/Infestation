extends Node2D

enum PHASE {DRAW, PLAY}

signal finished_discarding

var unit_queue: Array = []
@export var queue_offset: Vector2
@export var hand_size_limit: int
var hand: Array
@export var card_width: float = 256.0
@export var current_phase: PHASE = PHASE.DRAW
var current_wave = 1:
	get:
		return current_wave
	set(value):
		current_wave = value
		wave_display.text = " " + ("0" if current_wave - 10 < 0 else "") + str(current_wave) + "/" + str(wave_count) + " "
var wave_count = 10
var can_redraw = true
var discarding_cards: int = 0:
	get:
		return discarding_cards
	set(value):
		discarding_cards = value
		if value == 0:
			finished_discarding.emit()
var target: Node2D:
	get:
		return target
	set(value):
		target = value
@export_category("Node References")
@export var wave_display: Label
@export var draw_pile: Control
@export var discard_pile: Node2D
@export var hand_node: Node2D
@export var queue: Node2D
@export var timer_display: Control
@export var round_timer: Timer
@export var control_button_1: TextureRect
@export var control_button_2: TextureRect
@export var score_display: Label
@export var score: int:
	get:
		return Global.score
	set(value):
		Global.score = value
		score_display.text = "%06d" % value
		if score < 1000:
			grade.text = "A"
		elif score < 2000:
			grade.text = "A-"
		elif score < 3000:
			grade.text = "B"
		elif score < 4000:
			grade.text = "B-"
		elif score < 5000:
			grade.text = "C"
		elif score < 6000:
			grade.text = "C-"
		elif score < 7000:
			grade.text = "D"
		elif score < 8000:
			grade.text = "D-"
		elif score < 9000:
			grade.text = "E"
		elif score < 10000:
			grade.text = "E-"
		else:
			grade.text = "F"
@export var grade: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	await draw_pile.reload_deck()
	hand = []
	await draw_hand()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_hand_positions()
	if current_phase == PHASE.PLAY:
		update_timer()
	match current_phase:
		PHASE.DRAW:
			pass
		PHASE.PLAY:
			pass
	
func update_hand_positions():
	var hand_count = hand.size()
	var scl = clampf(hand_count, 2, 20)
	var shift = (card_width / scl * hand_count / 2)
	for i in hand.size():
		var current_card = hand[i]
		if not current_card.animating:
			current_card.hand_position = $Hand.global_position + Vector2((i * card_width / scl) - shift, 0)

func update_timer():
	timer_display.text = " " + str(ceil(round_timer.time_left)) + " "

func draw_card():
	var card = await draw_pile.draw_card()
	card = card.instantiate()
	card.name = card.card_name
	add_card_to_hand(card)
	card.global_position = draw_pile.global_position
	card.animate($Hand.global_position, card.default_scale)
	card.in_hand = true

func add_card_to_hand(card):
	if hand.size() < hand_size_limit:
		hand.append(card)
		$Hand.add_child(card)
	pass

func remove_card_from_hand(card, free: bool = true):
	for i in hand.size():
		if hand[i] == card:
			return remove_card_from_hand_index(i, free)

func remove_card_from_hand_index(card_index: int, free: bool = true):
	var c = hand.pop_at(card_index)
	if free: 
		c.queue_free()
		return null
	else:
		return c

func discard_card(card):
	discard_pile.discard_card(card)
	remove_card_from_hand(card, false)

func discard_hand():
	if hand.size() == 0:
		finished_discarding.emit()
	while hand.size() > 0:
		discard_card(hand.pop_back())
		discarding_cards += 1

func empty_discard_pile():
	await discard_pile.empty()

func draw_hand():
	for i in hand_size_limit:
		await draw_card()

func queue_unit(unit_path, unit_data):
	var unit = load(unit_path).instantiate()
	unit.name = "Unit" + str(unit_queue.size())
	unit.moving = false
	unit.attack = unit_data.attack
	unit.defense = unit_data.defense
	unit_queue.append(unit)
	queue.add_child(unit)
	unit.position += queue_offset
	queue_offset.y += 50

func requeue_unit(unit):
	unit.moving = false
	unit.target = null
	unit.reparent(queue, false)
	unit.position = Vector2.ZERO + queue_offset
	queue_offset.y += 50

func play():
	var delay = 1
	for unit in unit_queue:
		unit.delayed_spawn(delay, target)
		delay += 1
	target = null

func pause():
	get_tree().paused = true

func resume():
	get_tree().paused = false

func is_play_phase():
	return current_phase == PHASE.PLAY

func _on_control_button_1_gui_input(event):
	if event.is_action_pressed("Select"):
		match control_button_1.texture.region.position.x:
			0.0:
				if can_redraw:
					discard_hand()
					await finished_discarding
					await draw_hand()
					can_redraw = false
			32.0:
				control_button_1.texture.region.position.x = 64
				pause()
				round_timer.set_paused(true)
			64.0:
				control_button_1.texture.region.position.x = 32
				resume()
				if round_timer.is_paused():
					round_timer.set_paused(false)
				else:
					round_timer.start()

func _on_control_button_2_gui_input(event):
	if event.is_action_pressed("Select"):
		match control_button_2.texture.region.position.x:
			0.0:
				control_button_1.texture.region.position.x = 32
				control_button_2.texture.region.position.x = 32
				current_phase = PHASE.PLAY
				play()
				round_timer.start()
			32.0:
				control_button_2.texture.region.position.x = 64
				Engine.set_time_scale(2.0)
			64.0:
				control_button_2.texture.region.position.x = 32
				Engine.set_time_scale(1.0)


func _on_round_timer_timeout():
	current_wave += 1
	round_timer.wait_time = 20.0
	update_timer()
	queue_offset.y = 50.0
	for unit in unit_queue:
		if unit and unit.is_inside_tree():
			requeue_unit(unit)
	draw_hand()
	control_button_1.texture.region.position.x = 0
	control_button_2.texture.region.position.x = 0
	current_phase = PHASE.DRAW

func increase_score(scor):
	score += scor
