extends Resource
class_name Geom

class Line:
	var _p1: Vector2
	var _p2: Vector2
	func _init(p1: Vector2, p2: Vector2):
		assert(p1 != p2, "Invalid Line: Equal Points")
		_p1 = p1
		_p2 = p2
	
	func points() -> Array:
		return [_p1, _p2]
	
	func length() -> float:
		return _p1.distance_to(_p2)
	
	func equals(line: Line) -> bool:
		return (_p1 == line._p1 and _p2 == line._p2) or (_p1 == line._p2 and _p2 == line._p1)
	
	func draw(node: CanvasItem, color: Color = Color(0, 0, 1)) -> void:
		node.draw_line(_p1, _p2, color, 4, true)

	func _to_string():
		return "(%s, %s), (%s, %s)" % [_p1.x, _p1.y, _p2.x, _p2.y]
	
class Triangle:
	var _ccw: bool
	var _p1: Vector2
	var _p2: Vector2
	var _p3: Vector2
	var _e1: Line
	var _e2: Line
	var _e3: Line

	func _init(p1: Vector2, p2: Vector2, p3: Vector2):
		assert(p1 != p2 and p2 != p3 and p3 != p1, "Invalid Triangle: Equal Points")
		assert( (p3.y - p2.y) * (p2.x - p1.x) != (p2.y - p1.y) * (p3.x - p2.x), "Invalid Traingle: Collinear Points" )
		_ccw = (p2.x - p1.x)*(p3.y - p1.y)-(p3.x - p1.x)*(p2.y - p1.y) > 0
		_p1 = p1
		_p2 = p2
		_p3 = p3
		_e1 = Line.new(p1, p2)
		_e2 = Line.new(p2, p3)
		_e3 = Line.new(p3, p1)
	
	func circumscribes(point: Vector2) -> bool:
		var px1 = _p1.x - point.x;
		var py1 = _p1.y - point.y;
		var px2 = _p2.x - point.x;
		var py2 = _p2.y - point.y;
		var px3 = _p3.x - point.x;
		var py3 = _p3.y - point.y;
		var check = (px1*px1 + py1*py1) * (px2*py3 - px3*py2) - (px2*px2 + py2*py2) * (px1*py3 - px3*py1) + (px3*px3 + py3*py3) * (px1*py2 - px2*py1) > 0;
		return check if _ccw else not check
	
	func points() -> Array:
		return [_p1, _p2, _p3]
	
	func edges() -> Array:
		return [_e1, _e2, _e3]
	
	func has_edge(edge: Line) -> bool:
		return edge.equals(_e1) or edge.equals(_e2) or edge.equals(_e3)
	
	func has_vertex(point: Vector2) -> bool:
		return point == _p1 or point == _p2 or point == _p3
	
	func draw(node: CanvasItem, color: Color = Color(1, 0, 0)) -> void:
		node.draw_line(_p1, _p2, color, 5, true)
		node.draw_line(_p2, _p3, color, 5, true)
		node.draw_line(_p3, _p1, color, 5, true)

	func _to_string():
		return "(%s, %s), (%s, %s), (%s, %s)" % [_p1.x, _p1.y, _p2.x, _p2.y, _p3.x, _p3.y]
