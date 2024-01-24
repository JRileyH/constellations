extends Node2D
class_name Constellation

# The diameter of the area of allowable points
@export var size: float = 4000.0
# How much allowable space can be between points
@export var space: float = 500.0
# How many points we attempt to fit within the space
@export var density: float = 0.1
# How many neighboring connections a point is likely to have (0.0-1.0)
@export var connectivity: float = 0.25
@export var randomness: float = 0.5

var _points: Array[Vector2] = []
var _connections: Array[Geom.Line] = []
var _updated: bool = false
var _debouncer: float = 0.0

func _ready():
	build()

func _process(delta):
	if _updated:
		_debouncer += delta
		if _debouncer > 1.0:
			_updated = false
			_debouncer = 0.0
			build()

func update_size(new_size: float):
	size = new_size
	_updated = true
	_debouncer = 0.0

func update_space(new_space: float):
	space = new_space
	_updated = true
	_debouncer = 0.0

func update_density(new_density: float):
	density = new_density
	_updated = true
	_debouncer = 0.0

func update_connectivity(new_connectivity: float):
	connectivity = new_connectivity
	_updated = true
	_debouncer = 0.0

func update_randomness(new_randomness: float):
	randomness = new_randomness
	_updated = true
	_debouncer = 0.0

func _too_close(_point: Vector2) -> bool:
	for point in _points:
		if point.distance_to(_point) < space:
			return true
	return false

func _random_point(retry: int = 0) -> Vector2:
	randomize()
	var angle = randf_range(0, PI*2)
	var distance = randf_range(-size/2, size/2)
	var point = Vector2(
		cos(angle) * distance,
		sin(angle) * distance
	)
	if retry > 10:
		return Vector2.ZERO
	if _too_close(point):
		return _random_point(retry + 1)
	return point

func build() -> void:
	# RESET DATA STRUCTIONS
	_points = []
	_connections = []
	# PLOT POINT LOCATIONS
	for i in int(round(size * density)):
		var new_point = _random_point()
		if new_point == Vector2.ZERO:
			continue
		_points.append(new_point)
	# TRIANGULATE ALL POINTS
	var super_triangle = BowyerWatson.min_inscribed_triangle(size/2)
	var triangulation = BowyerWatson.triangulate_lines(super_triangle, _points)
	# FIND MINIMAL SPANNING TREE
	var minimal_spanning_tree = Prim.minimal_spanning_tree(_points)
	# GENERATE EXTRA CONNECTIONS
	var extra_size: int = int(floor((triangulation.size() - minimal_spanning_tree.size()) * connectivity))
	var lowest_extras: Array[Geom.Line] = []
	var random_extras: Array[Geom.Line] = []
	if triangulation.size() > 0 and extra_size >= 2:
		# SAMPLE SHORTEST POSSIBLE CONNECTIONS
		var largest_extra: Geom.Line = triangulation[0]
		for line in triangulation:
			var already_used: bool = false
			for l in minimal_spanning_tree:
				if l.equals(line):
					already_used = true
					continue
			if already_used:
				continue
			if lowest_extras.size() < floor(extra_size * (1 - randomness)):
				lowest_extras.append(line)
				if line.length() > largest_extra.length():
					largest_extra = line
			else:
				if line.length() < largest_extra.length():
					lowest_extras.erase(largest_extra)
					lowest_extras.append(line)
					largest_extra = lowest_extras[0]
					for l in lowest_extras:
						if l.length() > largest_extra.length():
							largest_extra = l
		# SAMPLE RANDOM CONNECTIONS
		while random_extras.size() < floor(extra_size * randomness):
			randomize()
			var connection = triangulation[randi() % triangulation.size()]
			for line in minimal_spanning_tree:
				if line.equals(connection):
					triangulation.erase(connection)
					continue
			for line in lowest_extras:
				if line.equals(connection):
					triangulation.erase(connection)
					continue
			random_extras.append(connection)
	# CREATE NEIGHBOR RELATIONSHIPS
	_connections = minimal_spanning_tree + lowest_extras + random_extras
	queue_redraw()

func _draw():
	for line in _connections:
		draw_line(line._p1, line._p2, Color.RED, 4.0)
