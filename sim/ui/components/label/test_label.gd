# Handles the functionality of the individual test strings in the sidebars

extends PanelContainer


# Updates the text of the test label
func set_text(text):
	$container/label.set_text(text)
