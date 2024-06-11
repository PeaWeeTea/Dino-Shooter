extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.play("move_right")
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.play("move_left")
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		$AnimatedSprite2D.play("move_down")
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		$AnimatedSprite2D.play("move_up")
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	
	
	move_and_slide()
