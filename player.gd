extends CharacterBody2D

signal bullet_shot(bullet_scene, location, direction)

const BULLET_SCENE = preload("res://bullet.tscn")
const BULLET_SPAWN_DISTANCE = 10
var shot_ready = true

@export var speed = 100.0

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"),
	Input.get_axis("move_up", "move_down"))
	
	if direction.x > 0:
		$AnimatedSprite2D.play("move_right")
	elif direction.x < 0:
		$AnimatedSprite2D.play("move_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("move_down")
	elif direction.y < 0:
		$AnimatedSprite2D.play("move_up")

	velocity = direction.normalized() * speed
	move_and_slide()

func _process(delta):
	var bullet_direction = Vector2(Input.get_axis("shoot_left", "shoot_right"),
	Input.get_axis("shoot_up", "shoot_down"))
	
	# if player shot and shot cooldown is finished then shoot
	if bullet_direction and shot_ready:
		shoot(bullet_direction)
		$ShotCooldown.start()
		shot_ready = false

func shoot(direction):
	$BulletSpawn.position = Vector2(direction.x * BULLET_SPAWN_DISTANCE,
	direction.y * BULLET_SPAWN_DISTANCE)
	var bullet_spawn = $BulletSpawn.global_position
	
	bullet_shot.emit(BULLET_SCENE, bullet_spawn, direction)
	$ShotCooldown.start()

func _on_shot_cooldown_timeout():
	shot_ready = true
	$ShotCooldown.stop()
