extends Control

func popup(text):
	%Label.set_text(text)
	set_visible(true)

func _on_button_pressed():
	set_visible(false)
