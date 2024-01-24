extends Resource
class_name BowyerWatson

const SQRT3: float = 1.73205080757

static func min_inscribed_triangle(radius: float, origin: Vector2 = Vector2.ZERO) -> Geom.Triangle:
	var edge = (6*radius)/SQRT3
	var a = Vector2(origin.x, origin.y + (edge*SQRT3)/3)
	var b = Vector2(origin.x - (edge/2), origin.y - radius)
	var c = Vector2(origin.x + (edge/2), origin.y - radius)
	
	return Geom.Triangle.new(a, b, c)

static func triangulate_lines(tri: Geom.Triangle, points: Array[Vector2]) -> Array:
	var lines: Array = []
	for triangle in triangulate(tri, points):
		lines += triangle.edges()
	return lines

static func triangulate(tri: Geom.Triangle, points: Array[Vector2]) -> Array:
	var triangles: Array = [tri]
	for point in points:
		var bad_triangles: Array = []
		for triangle in triangles:
			if triangle.circumscribes(point):
				bad_triangles.append(triangle)
		var polygon: Array = []
		for triangle in bad_triangles:
			for edge in triangle.edges():
				var shared = false
				for other in bad_triangles:
					if other == triangle:
						continue
					if other.has_edge(edge):
						shared = true
						break
				if not shared:
					polygon.append(edge)
			triangles.erase(triangle)
		for edge in polygon:
			triangles.append(Geom.Triangle.new(edge._p1, edge._p2, point))
	var doomed_triangles: Array = []
	for triangle in triangles:
		for point in triangle.points():
			if tri.has_vertex(point):
				doomed_triangles.append(triangle)
				break
	for triangle in doomed_triangles:
		triangles.erase(triangle)
	return triangles
