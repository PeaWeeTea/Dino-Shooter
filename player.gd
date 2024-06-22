extends CharacterBody2D

signal lives_depleted
signal life_lost(current_lives)

@export var speed = 100.0
var lives = 3

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"),
	Input.get_axis("move_up", "move_down"))
	velocity = direction.normalized() * speed
	move_and_slide()
	
	if direction.x > 0:
		%PlayerSprite.play("move_right")
	elif direction.x < 0:
		%PlayerSprite.play("move_left")
	
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		lives -= 1
		if lives <= 0:
			lives_depleted.emit()
			queue_free()
		else:
			life_lost.emit(lives)
			queue_free()



