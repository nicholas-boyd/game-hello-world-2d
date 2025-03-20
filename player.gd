extends Area2D

# Variables
signal hit
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# ~Calculate movement direction based on input~
	var velocity = Vector2.ZERO # The player's movement vector.
	# Update movement vector based on input
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# Normalize vector (aka make it a unit vector) to ensure velocity is the same regardless of direction
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# $ is short for get_node(), which retrieves a child node starting from the current node
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	# ~Update position based on movement direction and defined velocity~
	# Multiply velocity by delta (time change between frames) to ensure velocity stays the same regardless of framerate
	# Update position based on velocity, and CLAMP (restrict) the position to stay within screensize bounds
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# ~Update Animation based on movement direction~
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		# Reset vertical flip when moving horizontally, menaing horizontal movement overrides vertical for animations
		$AnimatedSprite2D.flip_v = false
		# Flip horizontally if moving left
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		# Flip vertically if moving up and NOT horizontally
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body):
	# Player disappears after being hit to avoid multiple hits from a single collision, and the "hit" signal is emitted (sent)
	hide()
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
# Reset player position and reveal them for a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
