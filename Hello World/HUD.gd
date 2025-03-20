extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Display flavor text when starting a new game
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
# Display game over message and reset start menu UI after game over
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Badies!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)

# Hides unnecesary UI elements, then sends signal to start the game
func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

# Hide message after new game
func _on_message_timer_timeout():
	$Message.hide()
