extends CharacterBody2D

const BULLETPATH = preload("res://bullet.tscn")
const fire_rate = 0.33
const BULLET_SPAWN_DISTANCE = 15
var shoot_ready = true
var shot_direction = Vector2.ZERO

const SPEED = 100.0
	

func _physics_process(delta):
	velocity = Vector2.ZERO
	shot_direction = Vector2.ZERO
	
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
	
	
	if Input.is_action_pressed("shoot_down"):
		shot_direction.y += 1
	if Input.is_action_pressed("shoot_up"):
		shot_direction.y -= 1
	if Input.is_action_pressed("shoot_left"):
		shot_direction.x -= 1
	if Input.is_action_pressed("shoot_right"):
		shot_direction.x += 1
	
	print($ShotCooldown.time_left)
	if shot_direction and shoot_ready:
		print("I will shoot")
		$BulletSpawn.position.x = shot_direction.x * BULLET_SPAWN_DISTANCE
		$BulletSpawn.position.y = shot_direction.y * BULLET_SPAWN_DISTANCE
		shoot()
		print($ShotCooldown.time_left)
		$ShotCooldown.start()
		print($ShotCooldown.time_left)
		shoot_ready = false

func shoot():
	var bullet = BULLETPATH.instantiate()
	
	get_parent().add_child(bullet)
	bullet.position = $BulletSpawn.global_position
	 
	
	


func _on_shot_cooldown_timeout():
	print("Timer stopped")
	shoot_ready = true
	$ShotCooldown.stop()
