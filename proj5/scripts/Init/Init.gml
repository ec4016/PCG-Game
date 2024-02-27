#macro CELL_SIZE 16
#macro ENEM_DISTANCE 10
#macro ENEM_HEALTH 2

#region powerups
//permanent
#macro GRAZE false

//generated powerup
#macro RICHOCHET true
#macro HEALTH_BOOST false

#endregion

enum CELL_TYPES {
	WALL,
	ROOM,
	HALLWAY,
	COUNT
}

enum DIRECTIONS {
	NORTH,
	WEST,
	SOUTH,
	EAST,
	COUNT
}

randomize();