function DungeonRoom(_x1, _y1, _x2, _y2) constructor {
	
	// Top left corner coordinates
	x1 = _x1;
	y1 = _y1;
	// Bottom right corner coordinates
	x2 = _x2;
	y2 = _y2;
	
	// Calculate room's width and height
	width = x2 - x1 + 1;
	height = y2 - y1 + 1;
	
	hallways = ds_list_create();
}

function DungeonHallway(_x1, _y1, _x2, _y2, isNorthSouth) constructor{
	// Top left corner coordinates
	x1 = _x1;
	y1 = _y1;
	// Bottom right corner coordinates
	x2 = _x2;
	y2 = _y2;
	NorthSouth = isNorthSouth;
	
	// Calculate room's width and height
	width = x2 - x1 + 1;
	height = y2 - y1 + 1;

}