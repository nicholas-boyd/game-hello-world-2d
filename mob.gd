extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Load Mob sprites, and choose one at random (fly, swim, or walk)
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Connection from VisibleOnScreenNotifier2D; deletes the Mob node once it's left the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
