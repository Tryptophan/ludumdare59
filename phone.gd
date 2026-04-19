@tool
extends Node2D

signal finished

const GAMES = ["ads", "pattern", "password", "case-opening", "tos"]

enum State {IDLE, PLAYING, FINISHED}
var _state: State = State.IDLE
var _current_game: Node2D = null

@export var phone_size: Vector2 = Vector2(338, 600):
	set(v): phone_size = v; queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, phone_size), Color.BLACK, true)

func _ready() -> void:
	# _transition(State.IDLE)
	start()

func start() -> void:
	if _state == State.PLAYING:
		return
	_transition(State.PLAYING)


func _clear_screen() -> void:
	for child in get_children():
		child.queue_free()
	_current_game = null


func _transition(next: State) -> void:
	_clear_screen()
	_state = next
	match next:
		State.IDLE:
			_show_idle_screen()
		State.PLAYING:
			_start_game()
		State.FINISHED:
			_show_finish_screen()


func _show_idle_screen() -> void:
	var label = Label.new()
	label.text = "Idle"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(label)


func _start_game() -> void:
	var game_name = GAMES[randi() % GAMES.size()]
	var script = load("res://%s.gd" % game_name)
	_current_game = Node2D.new()
	_current_game.set_script(script)
	add_child(_current_game)
	_current_game.setup(Vector2.ZERO, phone_size)
	_current_game.finished.connect(_on_game_finished)


func _on_game_finished() -> void:
	finished.emit()
	_transition(State.FINISHED)


func _show_finish_screen() -> void:
	var label = Label.new()
	label.text = "Done!"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(label)
	await get_tree().create_timer(2.0).timeout
	_transition(State.IDLE)
