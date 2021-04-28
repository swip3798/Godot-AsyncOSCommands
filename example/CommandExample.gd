extends Control

func _on_Button_pressed():
	$Ping.execute(["google.de"])


func _on_Ping_command_successful(_arguments, output, exit_code):
	$RichTextLabel.text += "\nCommand finished successful [" + str(exit_code) + "]:\n"
	$RichTextLabel.text += output


func _on_Ping_command_failed(_arguments, output, exit_code):
	$RichTextLabel.text += "\nCommand failed [" + str(exit_code) + "]:\n"
	$RichTextLabel.text += output
