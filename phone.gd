@tool
extends Node2D

signal finished

const GAMES = ["ads", "pattern", "password"]

enum State { IDLE, PLAYING }
var _state: State = State.IDLE
var _current_game: Node2D = null

@export var phone_size: Vector2 = Vector2(338, 600):
	set(v): phone_size = v; queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, phone_size), Color.PINK, false)

func _ready() -> void:
	start()

func start() -> void:
	if _state == State.PLAYING:
		return
	_state = State.PLAYING
	var game_name = GAMES[randi() % GAMES.size()]
	var script = load("res://%s.gd" % game_name)
	_current_game = Node2D.new()
	_current_game.set_script(script)
	add_child(_current_game)
	_current_game.setup(Vector2.ZERO, phone_size)
	_current_game.finished.connect(_on_finished)


func _on_finished() -> void:
	if _current_game:
		_current_game.queue_free()
		_current_game = null
	_state = State.IDLE
	finished.emit()
	print("finished")