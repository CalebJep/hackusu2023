extends Node3D

@export var tile : PackedScene

var rooms = []
var doors = []
var matrix = {
	'startx': 0,
	'starty': 0,
	'endx': 0,
	'endy': 0,
	'values': [[]],
}

# even indices are x offsets, odd indices are y offsets
var directions = [1, 0, 0, 1, -1, 0, 0, -1]

# Called when the node enters the scene tree for the first time.
func _ready():
	generate(12, 6, 3)
	generate_matrix()
	print_matrix()
	mark_available_doors()
	print("\n")
	print_matrix()
	var yrot = 0
	for i in range(rooms.size()):
		
		var room = rooms[i] as Room
		for x in range(room.x, room.x + room.width):
			for y in range(room.y, room.y + room.height):
				var newTile = tile.instantiate() as Node3D
				newTile.position.x = x
				newTile.position.z = y
				newTile.rotate_y(yrot)
				get_node("/root/Node3D").add_child(newTile)
		yrot += 10

	doors = remove_duplicate_doors(doors)

	for door in doors:
		door = door as Door
		var doortile = tile.instantiate() as Node3D
		doortile.position.x = door.x
		doortile.position.z = door.y
		doortile.rotate_z(PI)
		get_node("/root/Node3D").add_child(doortile)

#note: destructive function
func remove_duplicate_doors(doors : Array):
	var kept_doors = []
	doors.shuffle()
	for door in doors:
		door = door as Door
		var keep = true
		for kdoor in kept_doors:
			if door.check_same(kdoor):
				keep = false
				break
		if keep:
			kept_doors.append(door)
	return kept_doors

func mark_available_doors():
	for j in range(matrix['endx'] - matrix['startx'] - 2):
		for i in range(matrix['endy'] - matrix['starty'] - 2):
			if matrix['values'][i][j] == 0:
				if matrix['values'][i - 1][j] == 0 and matrix['values'][i + 1][j] == 0:
					if matrix['values'][i][j - 1] != 0 and matrix['values'][i][j + 1] != 0 and matrix['values'][i][j - 1] != matrix['values'][i][j + 1]:
#						matrix['values'][i][j] = -1

#						var id_val = matrix['values'][i][j + 1]
#						for room in get_rooms_by_id(matrix['values'][i][j - 1]):
#							room.id = id_val
#							room.populate_matrix(matrix)
						doors.append(Door.new(j + matrix['startx'], i + matrix['starty'], [matrix['values'][i][j + 1], matrix['values'][i][j - 1]]))
						
				elif matrix['values'][i][j - 1] == 0 and matrix['values'][i][j + 1] == 0:
					if matrix['values'][i - 1][j] != 0 and matrix['values'][i + 1][j] != 0 and matrix['values'][i - 1][j] != matrix['values'][i + 1][j]:
#						matrix['values'][i][j] = -2

#						var id_val = matrix['values'][i + 1][j]
#						for room in get_rooms_by_id(matrix['values'][i - 1][j]):
#							room.id = id_val
#							room.populate_matrix(matrix, matrix['values'][i + 1][j])
						doors.append(Door.new(j + matrix['startx'], i + matrix['starty'], [matrix['values'][i + 1][j], matrix['values'][i - 1][j]] ))
						
func get_rooms_by_id(id : int):
	var ret = []
	for room in rooms:
		if room.id == id:
			ret.append(room)
	return ret
	
func generate_matrix():
	var row = [0]
	row.resize(matrix['endx'] - matrix['startx'])
	row.fill(0)
	for i in range(matrix['endy'] - matrix['starty'] + 1):
		matrix['values'].append(row.duplicate())
	matrix['values'].remove_at(0)
	for room in rooms:
		(room as Room).populate_matrix(matrix)

func print_matrix():
	for row in matrix['values']:
		prints(row)


func generate(roomCount, maxDim, minDim):
	var i = 2
	var q
	var width = randi_range(minDim, maxDim)
	var height = randi_range(minDim, maxDim)
	var newRoom = Room.new((-width / 2) as int, (-height / 2) as int, width, height, 1, matrix)
	var parentRoom = newRoom
	rooms.append(newRoom)
	while (i <= roomCount):
		if randi_range(1, 100) < 10:
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
			y_start = randi_range(parentRoom.y + 1, parentRoom.y + parentRoom.height - 2)
			x_offset -= width
			y_offset = randi_range(-(height / 2) + 1, (height / 2) - 1)
		elif x_offset > 0:
			y_start = randi_range(parentRoom.y + 1, parentRoom.y + parentRoom.height - 2)
			x_start += parentRoom.width

			y_offset = randi_range(-(height / 2) + 1, (height / 2) - 1)
		elif y_offset < 0:
			x_start = randi_range(parentRoom.x + 1, parentRoom.x + parentRoom.width - 2)
			y_offset -= height
			x_offset = randi_range(-(width / 2) + 1, (width / 2) - 1)
		else:
			y_start += parentRoom.height
			x_start = randi_range(parentRoom.x + 1, parentRoom.x + parentRoom.width - 2)

			x_offset = randi_range(-(width / 2) + 1, (width / 2) - 1)
		newRoom = Room.new(x_start + x_offset, y_start + y_offset, width, height, i, matrix)
		var can_place = true
		for room in rooms:
			if newRoom.check_overlap(room as Room):
				can_place = false
				break
		if can_place:
			parentRoom = newRoom
			rooms.append(newRoom)
#			doors.append(Vector2i(x_start, y_start))
			i += 1

class Room:
	var width
	var height
	var locklevel
	var x
	var y
	var id
	
	func _init(x, y, width, height, id, matrix):
		self.x = x
		self.y = y
		self.width = width
		self.height = height
		self.id = id
		if self.x - 1 < matrix['startx']:
			matrix['startx'] = self.x - 1
		elif self.x + self.width + 1 > matrix['endx']:
			matrix['endx'] = self.x + self.width + 1
		if self.y + 1 < matrix['starty']:
			matrix['starty'] = self.y + 1
		elif self.y + self.height + 1 > matrix['endy']:
			matrix['endy'] = self.y + self.height + 1
	
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
	
	
	func populate_matrix(matrix, id=self.id):
		for j in range(self.x - matrix['startx'], self.x + self.width - matrix['startx']):
			for i in range(self.y - matrix['starty'], self.y + self.height - matrix['starty']):
				matrix['values'][i][j] = id

class Door:
	var x : int
	var y : int
	var roomIds = []
	func _init(x : int, y : int, roomIds):
		self.x = x
		self.y = y
		self.roomIds = roomIds
		self.roomIds.sort()
	
	func check_same(other : Door):
		if other.roomIds == roomIds:
			return true
		else:
			return false
