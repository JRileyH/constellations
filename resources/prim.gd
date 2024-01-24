extends Resource
class_name Prim

static func minimal_spanning_tree(points: Array[Vector2]) -> Array[Geom.Line]:
	
	var cost: Dictionary = {}
	var edge: Dictionary = {}
	for point in points:
		cost[point] = INF
		edge[point] = null
	
	var lines: Array[Geom.Line] = []
	var unreached: Array[Vector2] = points.duplicate()
	
	while (unreached.size() != 0):
		var v = unreached[0]
		for p in unreached:
			if cost[p] < cost[v]:
				v = p
		unreached.erase(v)
		if edge[v] != null:
			lines.append(edge[v])
		for w in points:
			if w == v:
				continue
			var line = Geom.Line.new(v, w)
			var length = line.length()
			if w in unreached and length < cost[w]:
				cost[w] = length
				edge[w] = line

	return lines
