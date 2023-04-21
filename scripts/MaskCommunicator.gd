extends Node

onready var http_requester = $MainRequest
onready var request_nodes = $RequestNodes

signal REQUEST_COMPLETED

const HEADERS = ["Content-Type: application/json"]
const MASK_SIZE = [9, 10]

var IP_ADDR = "127.0.0.1"
var PORT = 2006
var conn_established: bool = false

func establish_mask_conn(ip: String, port: int):
	if not ip.is_valid_ip_address(): return
	if http_requester.request("http://" + ip + ":" + str(port) + "/get") == OK:
		conn_established = true
		PORT = port
		IP_ADDR = ip
		return OK
	else:
		conn_established = false
		return FAILED

func send_data(data: Dictionary):
	var query = JSON.print(data)
	var request = HTTPRequest.new()
	request.connect("request_completed", self, "_req_completed")
	request_nodes.add_child(request)
	if conn_established:
		request.request("http://" + IP_ADDR + ":" + str(PORT) + "/post", HEADERS, false, HTTPClient.METHOD_POST, query)
		yield(MaskCommunicator, "REQUEST_COMPLETED")
	return

func _req_completed(result, response_code, headers, body):
	emit_signal("REQUEST_COMPLETED")
