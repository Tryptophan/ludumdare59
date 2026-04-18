@tool
extends Node2D

signal finished

const GAMES = ["dots", "pattern", "password"]

@export var phone_size: Vector2 = Vector2(338, 600):
	set(v): phone_size = v; queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, phone_size), Color.PINK, false)

func _ready() -> void:
	# Randomly load mini game
	# var game_name = GAMES[randi() % GAMES.size()]
	# uncomment above for randomization. comment or delete below afterwards
	var game_name = GAMES[0]
	var script = load("res://%s.gd" % game_name)
	var game = Node2D.new()
	game.set_script(script)
	add_child(game)
	game.setup(Vector2.ZERO, phone_size)
	game.finished.connect(_on_finished)

func _on_finished() -> void:
	finished.emit()
	print("finished")
