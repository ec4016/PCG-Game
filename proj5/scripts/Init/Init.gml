#macro CELL_SIZE 16
#macro ENEM_DISTANCE 250
#macro ENEM_HEALTH 2

#region powerups
//permanent
#macro GRAZE true

//generated powerup
#macro RICHOCHET false
#macro HEALTH_BOOST false

#endregion

global.graze = false;
global.richochet = false;
global.healthBoost = false;

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