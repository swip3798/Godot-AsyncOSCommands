tool
extends Node

var threads: Array = []
var old_threads: Array = []
signal command_finished(path, arguments, output, identifier)
export var num_workers: int = 1

func _ready():
	_generate_workers(num_workers)

func cleanup_old_threads():
	for i in old_threads:
		i.wait_to_finish()

func _generate_workers(num: int):
	threads = []
	for i in range(num):
		threads.append(Thread.new())

func execute(path: String, arguments: PoolStringArray, identifier = null):
	var counter: int = 0
	for t in threads:
		if not t.is_active():
			t.start(self, "_thread_function", [path, arguments, counter, identifier])
			return OK
		counter += 1
	return ERR_LOCKED
	
func _thread_function(command: Array):
	var output_a: Array = []
	OS.execute(command[0], command[1], true, output_a)
	emit_signal("command_finished", command[0], command[1], output_a[0], command[3])
	old_threads.append(threads[command[2]])
	threads[command[2]] = Thread.new()
	return null

func set_num_workers(num_workers: int):
	self.num_workers = num_workers
	_generate_workers(self.num_workers)
	
func get_num_workers() -> int:
	return self.num_workers
	
func _exit_tree():
	cleanup_old_threads()
