extends Node

var position : Vector2i
var size : int
var tiles : Array
var possible_ports : Array
var ports: Array

func _init(_position, _size):
	position = _position
	size = _size
