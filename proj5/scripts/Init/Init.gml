#macro CELL_SIZE 16
#macro ENEM_DISTANCE 250
#macro ENEM_HEALTH 2

#region powerups
//permanent
//#macro GRAZE true

////generated powerup
//#macro RICHOCHET false
//#macro HEALTH_BOOST false


global.graze = false;
global.richochet = false;
global.healthBoost = 0;

global.spawns = [oHeartBooster, oRichochet, oBomb];
global.dropRate = 20;

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