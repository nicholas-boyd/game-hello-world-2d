extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Connection from the hit signal, emmitted by Player.
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	# Show game over UI, stop bg music and play death sound
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

# Connection from the start_game signal, emmitted by the HUD.
func new_game():
	# Clear mobs from previous run, update score and start position for new game
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	# Prep UI elements, display get ready message, and start bg music
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()

# Spawn a mob along MobPath and assign it a semi-random direction and speed
func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

# Increment score by 1 at a rate set by ScoreTimer
func _on_score_timer_timeout():
	score += 1
	
	# Update Score UI
	$HUD.update_score(score)

# Start MobTimer and ScoreTimer
func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
