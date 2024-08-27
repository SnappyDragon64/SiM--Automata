# Handles popups

extends Control


# Displays the popup window
func popup(text):
	%Label.set_text(text)
	set_visible(true)


# Hides the popup window
func _on_button_pressed():
	set_visible(false)
