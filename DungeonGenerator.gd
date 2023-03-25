extends Node3D

@export var tile : PackedScene

var rooms = []
#var tiles = []

# even indices are x offsets, odd indices are y offsets
var directions = [1, 0, 0, 1, -1, 0, 0, -1]

# Called when the node enters the scene tree for the first time.
func _ready():
	generate(20, 6, 2)
	var yrot = 0
	for room in rooms:
		yrot = randi_range(0, 360)
		room = room as Room
		for x in range(room.x, room.x + room.width):
			for y in range(room.y, room.y + room.height):
				var newTile = tile.instantiate() as Node3D
				newTile.position.x = x
				newTile.position.z = y
				newTile.rotate_y(yrot)
				get_node("/root/Node3D").add_child(newTile)



func generate(roomCount, maxDim, minDim):
	var i = 0
	var q
	var width = randi_range(minDim, maxDim)
	var height = randi_range(minDim, maxDim)
	var newRoom = Room.new((-width / 2) as int, (-height / 2) as int, width, height)
	var parentRoom = newRoom
	rooms.append(newRoom)
	while (i < roomCount):
		if randi_range(1, 100) < 20:
			parentRoom = rooms.pick_random() as Room
		width = randi_range(minDim, maxDim)
		height = randi_range(minDim, maxDim)
		#pick offset
		q = randi_range(0, 3)
		var x_start = parentRoom.x
		var y_start = parentRoom.y
		var x_offset = directions[q * 2]
		var y_offset = directions[q * 2 + 1]
		if x_offset < 0:
			y_start = randi_range(parentRoom.y, parentRoom.y + parentRoom.height)
			x_offset = -width
			y_offset = randi_range(-height / 2 + 1, height / 2 - 1)
		elif x_offset > 0:
			y_start = randi_range(parentRoom.y, parentRoom.y + parentRoom.height)
			x_start += parentRoom.width
			x_offset = 0
#			x_offset += parentRoom.width
			y_offset = randi_range(-height / 2 + 1, height / 2 - 1)
		elif y_offset < 0:
			x_start = randi_range(parentRoom.x, parentRoom.x + parentRoom.width)
			y_offset = -height
			x_offset = randi_range(-width / 2 + 1, width / 2 - 1)
		else:
			y_start += parentRoom.height
			x_start = randi_range(parentRoom.x, parentRoom.x + parentRoom.width)
#			y_offset += parentRoom.height
			y_offset = 0
			x_offset = randi_range(-width / 2 + 1, width / 2 - 1)
		newRoom = Room.new(x_start + x_offset, y_start + y_offset, width, height)
		var can_place = true
		for room in rooms:
			if newRoom.check_overlap(room as Room):
				can_place = false
		if can_place:
			rooms.append(newRoom)
			parentRoom = newRoom
			i += 1

class Room:
	var width
	var height
	var locklevel
	var x
	var y
	
	func _init(x, y, width, height):
		self.x = x
		self.y = y
		self.width = width
		self.height = height
	
	func check_overlap(otherRoom):
		otherRoom = otherRoom as Room
		if otherRoom.x >= x + width:
			return false
		elif otherRoom.y >= y + height:
			return false
		elif otherRoom.x + otherRoom.width < x:
			return false
		elif otherRoom.y + otherRoom.height < y:
			return false
		return true
	
	
	
