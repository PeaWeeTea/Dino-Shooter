extends CharacterBody2D

signal bullet_shot(bullet_scene, location, direction)

var cooldown_ready = true

@export var bullet_coyote_frames = 4
@onready var bullet_frame_count = 0
@onready var bullet_frame_list = []
@onready var coyote_ready = false


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


func _process(delta):
	var bullet_direction = Vector2(float(Input.get_axis("shoot_left", "shoot_right")),
	float(Input.get_axis("shoot_up", "shoot_down")))
	
	# every process frame if there is shooting input, check past 3 frames if bullet_direction
	# is the same, effectively giving coyote time for bullets
	if (bullet_frame_count < bullet_coyote_frames and bullet_direction != Vector2.ZERO):
		for vector in bullet_frame_list:
			if vector != bullet_direction:
				bullet_frame_list.clear()
				coyote_ready = false
				bullet_frame_count = 0
		bullet_frame_list.append(bullet_direction)
		bullet_frame_count += 1
	if bullet_frame_count == bullet_coyote_frames:
		coyote_ready = true
		bullet_frame_list.clear()
		bullet_frame_count = 0
	
	# if player shot and shot cooldown is finished then shoot
	if bullet_direction and cooldown_ready and coyote_ready:
		shoot(bullet_direction)
		$ShotCooldown.start()
		cooldown_ready = false
		coyote_ready = false


func shoot(direction):
	const BULLET_SCENE = preload("res://bullet.tscn")
	const BULLET_SPAWN_DISTANCE = 10
	
	$BulletSpawn.position = Vector2(direction.x * BULLET_SPAWN_DISTANCE,
	direction.y * BULLET_SPAWN_DISTANCE)
	var bullet_spawn = $BulletSpawn.global_position
	
	bullet_shot.emit(BULLET_SCENE, bullet_spawn, direction)
	$ShotCooldown.start()

func _on_shot_cooldown_timeout():
	cooldown_ready = true
	$ShotCooldown.stop()
