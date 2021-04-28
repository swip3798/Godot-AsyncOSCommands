tool
extends Node

onready var thread: Thread = Thread.new()
onready var _mutex: Mutex = Mutex.new()
var _is_running: bool = false

export var path: String = ""
export var arguments: PoolStringArray = []
export var error_checking: bool = true
export var expected_exit_code: int = 0

signal command_successful(arguments, output, exit_code)
signal command_failed(arguments, output, exit_code)

func _set_is_running(running: bool):
	_mutex.lock()
	_is_running = running
	_mutex.unlock()

func get_is_running() -> bool:
	_mutex.lock()
	var res = _is_running
	_mutex.unlock()
	return res

func execute(additional_arguments: PoolStringArray = []):
	while get_is_running():
		yield(Engine.get_main_loop(), "idle_frame")
	_cleanup()
	_execute_shell_command(additional_arguments)

func _execute_shell_command(additional_arguments: PoolStringArray):
	_set_is_running(true)
	var concat_arguments = arguments
	concat_arguments.append_array(additional_arguments)
	thread.start(self, "_thread_runner", [path, concat_arguments])

func _thread_runner(parameters):
	var path: String = parameters[0]
	var args: PoolStringArray = parameters[1]
	var output: Array = []
	var exit_code := OS.execute(path, args, true, output, true)
	if error_checking and expected_exit_code != exit_code:
		emit_signal("command_failed", args, output[0], exit_code)
	else:
		emit_signal("command_successful", args, output[0], exit_code)
	_set_is_running(false)

func _cleanup():
	if thread.is_active() and not get_is_running():
		thread.wait_to_finish()
	
func _exit_tree():
	_cleanup()
