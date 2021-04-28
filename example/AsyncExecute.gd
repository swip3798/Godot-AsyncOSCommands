extends Control

var counter = 0


func _on_Button_pressed():
	counter += 1
	$OSAsyncExecute.execute("ping", ["-n","1", "google.de"], str(counter))


func _on_OSAsyncExecute_command_finished(_path, _arguments, output, _exit_code, identifier):
	$RichTextLabel.text += "\nCommand finished [" +  identifier + "]:\n"
	$RichTextLabel.text += output
