extends CharacterBody2D

@export var SPEED: float = 500.0

var inputDirection: Vector2
var lastInputDirection: Vector2 = Vector2.DOWN
var isMoving: bool = false
@onready var sprite := $PlayerSprite
@onready var axeSprite := $AxeSprite

func _ready() -> void:
	axeSprite.visible = false

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		handle_attack()
		return

	inputDirection = get_input_direction()
	isMoving = inputDirection.length() > 0
	if isMoving:
		lastInputDirection = inputDirection
	velocity = inputDirection * SPEED
	move_and_slide()

	sprite.flip_h = lastInputDirection.x < 0
	set_animation("move" if isMoving else "idle")

	if axeSprite.visible and axeSprite.frame == axeSprite.sprite_frames.get_frame_count("swingRight") - 1:
		axeSprite.visible = false

func get_input_direction() -> Vector2:
	var x := int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	var y := int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
	return Vector2(x, y).normalized()

func set_animation(animation: String) -> void:
	var direction := ""
	if isMoving:
		direction = get_direction(inputDirection)
	else:
		direction = get_direction(lastInputDirection)

	sprite.play(animation + direction)

func get_direction(direction: Vector2) -> String:
	if direction.x > 0:
		return "Right"
	elif direction.x < 0:
		return "Left"
	elif direction.y > 0:
		return "Down"
	else:
		return "Up"

func handle_attack() -> void:
	axeSprite.visible = true
	axeSprite.flip_h = lastInputDirection.x < 0
	
	if lastInputDirection.x > 0:
		axeSprite.play("swingRight")
	elif lastInputDirection.x < 0:
		axeSprite.play("swingRight")
	elif lastInputDirection.y > 0:
		axeSprite.play("swingDown")
	else:
		axeSprite.play("swingUp")
