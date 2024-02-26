randomize()

// Get tile layer map id
var _wall_map_id = layer_tilemap_get_id("WallTiles");

//set up grid
width_ = room_width div CELL_WIDTH;
height_ = room_height div CELL_HEIGHT;
grid_ = ds_grid_create(width_, height_);
ds_grid_set_region(grid_, 0, 0, width_, height_, VOID);

//create controller
var _controller_x = width_ div 2;
var _controller_y = height_ div 2;
var _controller_dir = irandom(3);
var _steps = irandom_range(200, 400); //size of level

var _dir_change_odds = 1;

repeat (_steps) {
	grid_[# _controller_x, _controller_y] = FLOOR
	
	//rando direction
	if (irandom(_dir_change_odds) == _dir_change_odds) {
		_controller_dir = irandom(3);
	}
	
	//move controller
	var _x_dir = lengthdir_x(1, _controller_dir * 90);
	var _y_dir = lengthdir_y(1, _controller_dir * 90);
	_controller_x += _x_dir;
	_controller_y += _y_dir;
	
	//make sure we don't go outside the grid
	if (_controller_x < 2 || _controller_x >= width_ - 2) {
		_controller_x += -_x_dir * 2;
	}
	
	if (_controller_y < 2 || _controller_y >= height_ - 2) {
		_controller_y += -_y_dir * 2;
	}
}

for (var _y = 1; _y < height_ - 1; _y++) {
	for (var _x = 1; _x < height_ - 1; _x++) {
		if (grid_[# _x, _y] == FLOOR) {
			tilemap_set(_wall_map_id, 1, _x, _y);
		}
	}
}