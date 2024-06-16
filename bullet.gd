extends Area2D

@onready var direction = Vector2.from_angle($BulletDirection.rotation)

@export var speed = 300
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
