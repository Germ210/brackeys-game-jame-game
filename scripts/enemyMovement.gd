extends CharacterBody2D

@export var speed : float = 300.0
var player : Node2D = null
@onready var sprite = $Sprite

func _ready():
	player = get_parent().get_node("Player")

func _physics_process(_delta : float) -> void:
	if player:
		var direction: Vector2 = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		getAnimation()

func getAnimation() -> void:
	var x = Input.get_axis("Left", "Right")
	var y = Input.get_axis("Up", "Down")

	if x != 0 and y != 0:
		sprite.play("moveLeft")
		sprite.flip_h = x < 0
	elif x != 0:
		sprite.play("moveLeft")
		sprite.flip_h = x < 0
	elif y > 0:
		sprite.play("moveDown")
	elif y < 0:
		sprite.play("moveUp")
