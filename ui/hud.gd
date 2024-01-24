extends CanvasLayer
class_name HUD

@export var constellation: Constellation

func rebuild_constellation():
	if constellation:
		constellation.build()

func update_constellation_size(size: float):
	if constellation:
		constellation.update_size(size)

func update_constellation_space(space: float):
	if constellation:
		constellation.update_space(space)

func update_constellation_density(density: float):
	if constellation:
		constellation.update_density(density)
		
func update_constellation_connectivity(connectivity: float):
	if constellation:
		constellation.update_connectivity(connectivity)

func update_constellation_randomness(randomness: float):
	if constellation:
		constellation.update_randomness(randomness)
