extends Node2D

class_name battleComponent

@export var health : float = 100.0
@export var attack : float = 20.0
signal hit

func onHit(strike : float) -> void:
	health -= strike
	
func die(body : CharacterBody2D, animation : AnimatedSprite2D) -> void:
	if body.name == "Player":
		animation.play("death")
