# Godot-AsyncOSCommands
Godot Plugin for executing OS commands asynchronous, similar to the HTTPRequest Node.

## Usage
To have a direct look on how to use the nodes, check out the example Scences in the example folder.
### "Low"-Level API
The OSAsyncExecute Node has a similar execute function as the OS singleton. The first argument is the path, the second is an array of arguments. The third is an optional identifier. When the command is finished, the Node will emit the finished signal. If the execute method is called, while a command is still running, the command will be queued in and executed as soon as the Node is free again. 

```GDScript

func _ready():
    $OSAsyncExecute.execute("ping", ["-n","1", "google.de"], "ping_command")


func _on_OSAsyncExecute_command_finished(path, arguments, output, exit_code, identifier):
	print("finished ", identifier, " ", output)

```
### High-Level API
There is also a OSCommand Node, which represents one executable which is called. The path and arguments are set via exported variables. There is also an optional error check if the process is returning an unexpected exit code. This allows you to have a little more high-level API where one node represents one endpoint. When calling the execute method of the node, the arguments of the method call are concatenated to the arguments which are already set in the exported variables. The overall aim of this node is to move as much information as possible from the source code to the node tree.  

## Installation
To use AsyncOSCommands, download the addons.zip file from the latest release, then simply copy the addons folder in your projects root directory. Afterwards go into your Project Settings and enable the AsyncOSCommands in the plugin tab. Then the OSAsyncExecute Node should appear when you create a new node.