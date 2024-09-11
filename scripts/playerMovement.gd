extends CharacterBody2D

@export var SPEED: float = 500.0

var inputDirection: Vector2
var lastInputDirection: Vector2 = Vector2.DOWN
var isMoving: bool = false
var isAttacking = false

@onready var sprite := $PlayerSprite
@onready var axeSprite := $AxeSprite
@onready var battleComponent := load("res://scenes/BattleComponent.tscn")

func _ready() -> void:
	axeSprite.visible = false
	print(battleComponent)

func _physics_process(_delta: float) -> void:
	isAttacking = false
	if Input.is_action_just_pressed("attack"):
		isAttacking = true
		handleAttack()
		return

	inputDirection = getInputDirection()
	isMoving = inputDirection.length() > 0
	if isMoving:
		lastInputDirection = inputDirection
	velocity = inputDirection * SPEED
	move_and_slide()

	sprite.flip_h = lastInputDirection.x < 0
	setAnimation("move" if isMoving else "idle")

	if axeSprite.visible and axeSprite.frame == axeSprite.sprite_frames.get_frame_count("swingRight") - 1:
		axeSprite.visible = false

func getInputDirection() -> Vector2:
	return (Vector2(int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left")),
					int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up")))).normalized()

func setAnimation(animation: String) -> void:
	sprite.play(animation + getDirectionSuffix(lastInputDirection))

func getDirectionSuffix(direction: Vector2) -> String:
	if direction.x > 0 or direction.x < 0:
		return "Right"
	elif direction.y > 0:
		return "Down"
	else:
		return "Up"

func handleAttack() -> void:
	$HurtBox/BattleComponent.hit.emit()
	axeSprite.visible = true
	axeSprite.flip_h = lastInputDirection.x < 0
	axeSprite.play("swing" + getDirectionSuffix(lastInputDirection))


func onHit() -> void:
	pass
