extends CharacterBody2D

@export var speed = 100.0

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"),
	Input.get_axis("move_up", "move_down"))
	
	if direction.x > 0:
		$AnimatedSprite2D.play("move_right")
	elif direction.x < 0:
		$AnimatedSprite2D.play("move_left")

	velocity = direction.normalized() * speed
	move_and_slide()

