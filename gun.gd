extends Node2D

var cooldown_ready = true
const BULLET_SPAWN_DISTANCE = 15
@export var bullet_coyote_frames = 4
@onready var bullet_frame_count = 0
@onready var bullet_frame_list = []
@onready var coyote_ready = false


func _physics_process(delta):
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
		# set bullet spawn position and rotation
		%BulletSpawn.position.x = bullet_direction.x * BULLET_SPAWN_DISTANCE
		%BulletSpawn.position.y = bullet_direction.y * BULLET_SPAWN_DISTANCE
		%BulletSpawn.look_at(global_position) # bullet spawn rotates towards gun
		%BulletSpawn.global_rotation -= PI # rotates bullet spawn 180 degrees
		
		shoot()



func shoot():
	const BULLET_SCENE = preload("res://bullet.tscn")
	var new_bullet = BULLET_SCENE.instantiate()
	
	new_bullet.global_position = %BulletSpawn.global_position
	new_bullet.global_rotation = %BulletSpawn.global_rotation
	%BulletSpawn.add_child(new_bullet)
	$ShotCooldown.start()
	cooldown_ready = false
	coyote_ready = false


func _on_shot_cooldown_timeout():
	cooldown_ready = true
	$ShotCooldown.stop()
