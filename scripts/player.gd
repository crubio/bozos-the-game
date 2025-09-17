extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
signal hit # signal the player sends out when hit by an enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	# delta here is frame length, the amount of time it took the frame to complete.
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size) # limits movement to screen size.

	# Rembering how vectors work here, we can do our flip_h & flip_v
	#LEFT = Vector2(-1, 0) Left unit vector. Represents the direction of left.
	#RIGHT = Vector2(1, 0) Right unit vector. Represents the direction of right.
	#UP = Vector2(0, -1) Up unit vector. Y is down in 2D, so this vector points -Y.
	#DOWN = Vector2(0, 1) Down unit vector. Y is down in 2D, so this vector points +Y.
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

# connector function, notice the green arrowbox
func _on_body_entered(body: Node2D) -> void:
	hide() # disappear after a hit
	hit.emit()
	
	# From the docs:
	#Disabling the area's collision shape can cause an error if it happens in the middle of the engine's
	#collision processing. Using set_deferred() tells Godot to wait to disable the shape until it's safe to do so.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	

func game_over() -> void:
	pass # Replace with function body.
