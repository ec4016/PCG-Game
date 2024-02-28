var _dungeonWidth = floor(room_width / CELL_SIZE);
var _dungeonHeight = floor(room_height / CELL_SIZE);
dungeon = ds_grid_create(_dungeonWidth, _dungeonHeight);

// Keeps track of all room structs
roomList = ds_list_create();

// Room size ranges
roomWidthMin = 22;
roomWidthMax = 26;
roomHeightMin = 22;
roomHeightMax = 26;

// Hallway size ranges
hallwayLengthMin = 6;
hallwayLengthMax = 16;
hallwayWidthMin = 4;
hallwayWidthMax = 6;

// Room to create a new room from
currentRoom = noone;

// 1 in n chance of branching from the newly created room
branchOdds = 4;

// The number of failed iterations to create a new room
iterations = 0;

// The maximum number of failed iterations before quitting generation
iterationMax = 50;

wallTileIndex = 16;

richochetProb = 0.2;

highestLevel = 0;
currLevel = 0;

GenerateNewDungeon = function() {
	
	// Reset dungeon data
	iterations = 0;
	ds_list_clear(roomList);
	tilemap_clear(layer_tilemap_get_id(layer_get_id("Tiles")), 0);
	with(obj_wall){
		instance_destroy();
	}
	with(oTracker){
		instance_destroy();
	}
	with(oTurret){
		instance_destroy();
	}
	with(obj_bullet){
		instance_destroy();
	}
	with(oEnemBullet){
		instance_destroy();
	}
	with(obj_hazard){
		instance_destroy();
	}
	with(oHeartBooster){
		instance_destroy();
	}
	with(oRichochet){
		instance_destroy();
	}
	with(oBomb){
		instance_destroy();
	}
	var _dungeonWidth = ds_grid_width(dungeon);
	var _dungeonHeight = ds_grid_height(dungeon);
	
	// Fill the whole dungeon with walls to start
	ds_grid_set_region(dungeon, 0, 0, _dungeonWidth - 1, _dungeonHeight - 1, CELL_TYPES.WALL);
	
	while (iterations < iterationMax) {
		
		// Generate a random room width and height
		var _roomWidth = irandom_range(roomWidthMin, roomWidthMax);
		var _roomHeight = irandom_range(roomHeightMin, roomHeightMax);
		
		if (!ds_list_empty(roomList)) {
			
			var _createdHallway = false;
			
			// Make a direction of possible directions to traverse from the current room
			var _dirList = ds_list_create();
			ds_list_add(_dirList, DIRECTIONS.WEST, DIRECTIONS.EAST, DIRECTIONS.NORTH, DIRECTIONS.SOUTH);
	
			while (!ds_list_empty(_dirList)) {
				
				// Remove a random cardinal direction
				
				var _dirIndex = irandom(ds_list_size(_dirList) - 1);
			
				var _dir = _dirList[| _dirIndex];
				ds_list_delete(_dirList, _dirIndex);
				
				// Generate a random hallway length and width
				var _hallwayLength = irandom_range(hallwayLengthMin, hallwayLengthMax);
				var _hallwayWidth = irandom_range(hallwayWidthMin, hallwayWidthMax);
		
				var _roomX1, _roomY1, _roomX2, _roomY2;
			
				// Calculate the top left corner of the new room based on distance and direction
				switch (_dir) {
					case DIRECTIONS.WEST:
						_roomX1 = currentRoom.x1 - _hallwayLength - _roomWidth;
						_roomY1 = irandom_range(currentRoom.y1 - _roomHeight + _hallwayWidth, currentRoom.y2 - (_hallwayWidth - 1));
						break;
					case DIRECTIONS.EAST:
						_roomX1 = currentRoom.x2 + _hallwayLength + 1;
						_roomY1 = irandom_range(currentRoom.y1 - _roomHeight + _hallwayWidth, currentRoom.y2 - (_hallwayWidth - 1));
						break;
					case DIRECTIONS.NORTH:
						_roomX1 = irandom_range(currentRoom.x1 - _roomWidth + _hallwayWidth, currentRoom.x2 - (_hallwayWidth - 1));
						_roomY1 = currentRoom.y1 - _hallwayLength - _roomHeight;
						break;
					case DIRECTIONS.SOUTH:
						_roomX1 = irandom_range(currentRoom.x1 - _roomWidth + _hallwayWidth, currentRoom.x2 - (_hallwayWidth - 1));
						_roomY1 = currentRoom.y2 + _hallwayLength + 1;
						break;
				}
			
				//Calculate the bottom right corner of the new room.
				_roomX2 = _roomX1 + _roomWidth - 1;
				_roomY2 = _roomY1 + _roomHeight - 1;
				
				// Skip this direction if new room is out of bounds
				if (_roomX1 <= 0 || _roomX1 >= _dungeonWidth - 2 - _roomWidth || _roomY1 <= 0 || _roomY1 >= _dungeonHeight - 2 - _roomHeight) {
					continue;
				}
			
				var _hallwayX1, _hallwayX2, _hallwayY1, _hallwayY2;
				var _minRange, _maxRange;
				var isNorthSouth;
				//Connect the new room and previous room with a hallway, and calculate the hallway's four corners
				switch (_dir) {
					case DIRECTIONS.WEST:
						isNorthSouth = false;
						_hallwayX1 = _roomX2 + 1;
						_hallwayX2 = _hallwayX1 + _hallwayLength - 1;
                 
						if (_roomY1 < currentRoom.y1) {
							_minRange = currentRoom.y1;
						}
						else {
							_minRange = _roomY1;
						}
                 
						if (_roomY2 > currentRoom.y2) {
							_maxRange = currentRoom.y2 - (_hallwayWidth - 1);
						}
						else {
							_maxRange = _roomY2 - (_hallwayWidth - 1);
						}
                 
						_hallwayY1 = _minRange + round(abs(_maxRange - _minRange) / 2);
						_hallwayY2 = _hallwayY1 + (_hallwayWidth - 1);
						break;
					case DIRECTIONS.EAST:
						isNorthSouth = false;
						_hallwayX1 = _roomX1 - _hallwayLength;
						_hallwayX2 = _hallwayX1 + _hallwayLength - 1;
                 
						if (_roomY1 < currentRoom.y1) {
							_minRange = currentRoom.y1;
						}
						else {
							_minRange = _roomY1;
						}
                 
						if (_roomY2 > currentRoom.y2) {
							_maxRange = currentRoom.y2 - (_hallwayWidth - 1);
						}
						else {
							_maxRange = _roomY2 - (_hallwayWidth - 1);
						}
                 
						_hallwayY1 = _minRange + round(abs(_maxRange - _minRange) / 2);
						_hallwayY2 = _hallwayY1 + (_hallwayWidth - 1);
						break;
					case DIRECTIONS.NORTH:
						isNorthSouth = true;

						if (_roomX1 < currentRoom.x1) {
							_minRange = currentRoom.x1;
						}
						else {
							_minRange = _roomX1;
						}
                 
						if (_roomX2 > currentRoom.x2) {
							_maxRange = currentRoom.x2 - (_hallwayWidth - 1);
						}
						else {
							_maxRange = _roomX2 - (_hallwayWidth - 1);
						}
                 
						_hallwayX1 = _minRange + round(abs(_maxRange - _minRange) / 2);
						_hallwayX2 = _hallwayX1 + (_hallwayWidth - 1);
						_hallwayY1 = _roomY2 + 1;
						_hallwayY2 = _hallwayY1 + _hallwayLength - 1;
						break;
					case DIRECTIONS.SOUTH:
						isNorthSouth = true;
						if (_roomX1 < currentRoom.x1) {
							_minRange = currentRoom.x1;
						}
						else {
							_minRange = _roomX1;
						}
                 
						if (_roomX2 > currentRoom.x2) {
							_maxRange = currentRoom.x2 - (_hallwayWidth - 1);
						}
						else {
							_maxRange = _roomX2 - (_hallwayWidth - 1);
						}
                 
						_hallwayX1 = _minRange + round(abs(_maxRange - _minRange) / 2);
						_hallwayX2 = _hallwayX1 + (_hallwayWidth - 1);
						_hallwayY1 = _roomY1 - _hallwayLength;
						_hallwayY2 = _hallwayY1 + _hallwayLength - 1;
						break;
				}
			
				var _isTouching = false;
			
				// Check if the hallway is touching a non-wall space
				
				for (var xx = _roomX1 - 1; xx <= _roomX2 + 1; xx++) {
					
					for (var yy = _roomY1 - 1; yy <= _roomY2 + 1; yy++) {
					    if (dungeon[# xx, yy] != CELL_TYPES.WALL) {
					        _isTouching = true;
							break;
					    }
					}
					
					if (_isTouching) {
						break;
					}
				}
				
				if (!_isTouching) {
					
					//Check if the hallway is touching another room
				
					for (xx = _hallwayX1 - 1; xx <= _hallwayX2 + 1; xx++) {
					
						for (yy = _hallwayY1 - 1; yy <= _hallwayY2 + 1; yy++) {
						    if (xx < currentRoom.x1 || xx > currentRoom.x2 || yy < currentRoom.y1 || yy > currentRoom.y2) {
						        if (dungeon[# xx, yy] == CELL_TYPES.ROOM) {
						            _isTouching = true;
									break;
						        }
						    }
						}
					
						if (_isTouching) {
							break;
						}
					}
					
					if (!_isTouching) {
						//create hallway object first
						var hallway = new DungeonHallway(_hallwayX1, _hallwayY1, _hallwayX2, _hallwayY2, isNorthSouth);
						//add hallway to previous room
						ds_list_add(currentRoom.hallways, hallway);
						//create and paint new room
						var newRoom = CreateRoom(_roomX1, _roomY1, _roomX2, _roomY2);
						//paint hallways
						CreateHallway(_hallwayX1, _hallwayY1, _hallwayX2, _hallwayY2, isNorthSouth);
						//add hallway to new room
						ds_list_add(newRoom.hallways, hallway);
						_createdHallway = true;
						iterations = -1;
						break;
					}
				}
			}
			
			iterations++;
		
			ds_list_destroy(_dirList);
			
		    if (random(branchOdds) < 1) {
		        currentRoom = roomList[| irandom(ds_list_size(roomList) - 1)];
			}
		}
		else {
			
			// Position the room in a random location within bounds of the dungeon
			var _roomX1 = irandom(_dungeonWidth - _roomWidth) + 1;
			var _roomY1 = irandom(_dungeonHeight - _roomHeight) + 1;
			var _roomX2 = _roomX1 + _roomWidth - 1;
			var _roomY2 = _roomY1 + _roomHeight - 1;
	
			CreateRoom(_roomX1, _roomY1, _roomX2, _roomY2);
		}
	}

	for (var xx = 0; xx < _dungeonWidth; xx++) {
		for (var yy = 0; yy < _dungeonHeight; yy++) {
		
			var _cell = dungeon[# xx, yy];
			
			var _tileInd = 0;
		
			if (_cell = CELL_TYPES.ROOM) {
				_tileInd = 1;
			}
			else if (_cell == CELL_TYPES.HALLWAY) {
				_tileInd = 2;
			}
			
			tilemap_set(layer_tilemap_get_id(layer_get_id("Tiles")), _tileInd, xx, yy);
		}
	}
	
	//test for new dungeonRoom structure
	/*var roomCount = ds_list_size(roomList);
	
	for(var i = 0; i < roomCount; i++)
	{
		var testRoom = ds_list_find_value(roomList,i);
		show_debug_message(string(testRoom.x1) + ", " + string(testRoom.y1) + " to " + string(testRoom.x2) + ", " + string(testRoom.y2));
		var hallwayCount = ds_list_size(testRoom.hallways);
		show_debug_message(string(hallwayCount));
	}*/
	
	//Init player
	var firstRoom = ds_list_find_value(roomList, 0);

	var centerX = (firstRoom.x1 + firstRoom.x2) / 2;
	var centerY = (firstRoom.y1 + firstRoom.y2) / 2;
	var playerInstance;
	var playerLives;
	if(instance_exists(obj_player)){
		playerInstance = instance_find(obj_player, 0);
		playerInstance.x = centerX * CELL_SIZE;
		playerInstance.y = centerY * CELL_SIZE;
	}
	else{
		playerInstance = instance_create_layer(centerX * CELL_SIZE + (CELL_SIZE / 2), centerY * CELL_SIZE + (CELL_SIZE / 2), "Dungeon", obj_player);
	}
	
	//set healthBoost prob
	if(playerInstance){
		playerLives = playerInstance.playerLives;
	}
	var healthBoostProb;
	if(currLevel>=10){
		healthBoostProb = 0.1;
	}
	else if(playerLives <=1){
		healthBoostProb = 0.2;
	}
	else if(playerLives >= 3){
		healthBoostProb = 0.1;
	}
	else if(playerLives >=5){
		healthBoostProb = 0.01;
	}
	else{
		healthBoostProb = 0.15;
	}
	var isBoostGenerated = false;
	show_debug_message(string(playerLives));
	
	//Select exit room
	var deadEnd = ds_list_create();
	for(var i = 1;i < ds_list_size(roomList);i++){
		var rm = ds_list_find_value(roomList,i);
		if(ds_list_size(rm.hallways)<=1){
			ds_list_add(deadEnd,{roomId: rm, roomInd: i});
		}
	}
	var reloadRand = irandom(ds_list_size(deadEnd) - 1);
	var reloadRoom = ds_list_find_value(deadEnd, reloadRand);
	var reloadRoomInd = reloadRoom.roomInd;
	
	//Generating rooms
	var richochetRoom = noone;
	show_debug_message(string(global.richochet));
	if(!global.richochet && random_range(0,1)<richochetProb){
		richochetRoom = irandom_range(1, ds_list_size(roomList)-1);
	}
	for(var i = 0; i < ds_list_size(roomList);i++){
		var rm = ds_list_find_value(roomList,i);
		var enemy = [];
		var hazards = [];
		if(i!=0 && i!=reloadRoomInd){
			hazards = CreateHazards(rm);
			enemy = CreateEnemies(rm.x1,rm.y1,rm.x2,rm.y2, hazards);
			if(richochetRoom==i){
				CreateRichochet(rm, hazards);
			}
			else if(random_range(0,1) < healthBoostProb && !isBoostGenerated){
				CreateHealthBooster(rm, hazards);
			}
		}
	}
	
	
	//Generate dungeon reload instance in this room;
	centerX = (reloadRoom.roomId.x1 + reloadRoom.roomId.x2) / 2;
	centerY = (reloadRoom.roomId.y1 + reloadRoom.roomId.y2) / 2;
	
	var exitInstance = instance_create_layer(centerX * CELL_SIZE, centerY * CELL_SIZE, "Dungeon", oDunReload);


	
}

CreateRoom = function(_x1, _y1, _x2, _y2) {
	
	currentRoom = new DungeonRoom(_x1, _y1, _x2, _y2);
	ds_list_add(roomList, currentRoom);
	
	// Fill the dungeon with a room
	ds_grid_set_region(dungeon, _x1, _y1, _x2, _y2, CELL_TYPES.ROOM);
	
	/*for (var xx = _x1 - 1; xx <= _x2 + 1; xx++) {
        tilemap_set(layer_tilemap_get_id(layer_get_id("WallTile")), wallTileIndex, xx, _y1 - 1);
        tilemap_set(layer_tilemap_get_id(layer_get_id("WallTile")), wallTileIndex, xx, _y2 + 1);
    }
    for (var yy = _y1 - 1; yy <= _y2 + 1; yy++) {
        tilemap_set(layer_tilemap_get_id(layer_get_id("WallTile")), wallTileIndex, _x1 - 1, yy);
        tilemap_set(layer_tilemap_get_id(layer_get_id("WallTile")), wallTileIndex, _x2 + 1, yy);
    }*/
	var cellSize = 16;
    for (var xx = _x1 - 1; xx <= _x2 + 1; xx++) {
        instance_create_layer(xx * cellSize, (_y1 - 1) * cellSize, "WallTile", obj_wall);
        instance_create_layer(xx * cellSize, (_y2 + 1) * cellSize, "WallTile", obj_wall);
    }
    for (var yy = _y1 - 1; yy <= _y2 + 1; yy++) {
        instance_create_layer((_x1 - 1) * cellSize, yy * cellSize, "WallTile", obj_wall);
        instance_create_layer((_x2 + 1) * cellSize, yy * cellSize, "WallTile", obj_wall);
    }
	
	return currentRoom;
	//CreateHazards(_x1,_y1,_x2,_y2);
}

CreateHallway = function(_x1, _y1, _x2, _y2, isNorthSouth) {
	// Fill the dungeon with a hallway
	ds_grid_set_region(dungeon, _x1, _y1, _x2, _y2, CELL_TYPES.HALLWAY);
	/*
	var wallLayer = layer_tilemap_get_id(layer_get_id("WallTile"));
    
    if (isNorthSouth) {
        for (var temp_y = _y1; temp_y <= _y2; temp_y++) {
            tilemap_set(wallLayer, wallTileIndex, _x1 - 1, temp_y);
            tilemap_set(wallLayer, wallTileIndex, _x2 + 1, temp_y);
        }
		for (var temp_x = _x1; temp_x <= _x2; temp_x++) {
            tilemap_set(wallLayer, 0, temp_x, _y1);
            tilemap_set(wallLayer, 0, temp_x, _y2);
        }
    } else {
        for (var temp_x = _x1; temp_x <= _x2; temp_x++) {
            tilemap_set(wallLayer, wallTileIndex, temp_x, _y1 - 1);
            tilemap_set(wallLayer, wallTileIndex, temp_x, _y2 + 1);
        }
		for (var temp_y = _y1; temp_y <= _y2; temp_y++) {
            tilemap_set(wallLayer, 0, _x1 , temp_y);
            tilemap_set(wallLayer, 0, _x2, temp_y);
        }
    }*/
	
	var cellSize = 16;
    
    if (isNorthSouth) {
        for (var temp_y = _y1; temp_y <= _y2; temp_y++) {
            instance_create_layer((_x1 - 1) * cellSize, temp_y * cellSize, "Dungeon", obj_wall);
            instance_create_layer((_x2 + 1) * cellSize, temp_y * cellSize, "Dungeon", obj_wall);
        }
		for (var temp_x = _x1; temp_x <= _x2; temp_x++) {
            var instanceLeft = instance_position((temp_x) * cellSize, _y1 * cellSize, obj_wall);
	        if (instanceLeft != noone) instance_destroy(instanceLeft);

	        var instanceRight = instance_position((temp_x) * cellSize, _y2 * cellSize, obj_wall);
	        if (instanceRight != noone) instance_destroy(instanceRight);
	        }
    } else {
        for (var temp_x = _x1; temp_x <= _x2; temp_x++) {
            instance_create_layer(temp_x * cellSize, (_y1 - 1) * cellSize, "Dungeon", obj_wall);
            instance_create_layer(temp_x * cellSize, (_y2 + 1) * cellSize, "Dungeon", obj_wall);
        }
		for (var temp_y = _y1; temp_y <= _y2; temp_y++) {
	        var instanceLeft = instance_position((_x1) * cellSize, temp_y * cellSize, obj_wall);
	        if (instanceLeft != noone) instance_destroy(instanceLeft);

	        var instanceRight = instance_position((_x2) * cellSize, temp_y * cellSize, obj_wall);
	        if (instanceRight != noone) instance_destroy(instanceRight);
	    }
    }
	

}

CreateHealthBooster = function(rm, hazards){
	var healthBooster = instance_create_layer((rm.x1 + rm.x2)/2 * CELL_SIZE, (rm.y1+rm.y2)/2 * CELL_SIZE, "Dungeon", oHeartBooster);
	var iter = 0;
	var dist = 64;
	var validPosition = false;
	var healthBoosterWidth = sprite_get_width(healthBooster.sprite_index);
	var healthBoosterHeight = sprite_get_height(healthBooster.sprite_index);
	var posX, posY;
	var adjusted_x1 = rm.x1 * CELL_SIZE;
	var adjusted_y1 = rm.y1 * CELL_SIZE;
	var adjusted_x2 = rm.x2 * CELL_SIZE - healthBoosterWidth;
	var adjusted_y2 = rm.y2 * CELL_SIZE - healthBoosterHeight;
	
	while(!validPosition && iter<50){
		validPosition = true;
		posX = irandom_range(adjusted_x1, adjusted_x2);
		posY = irandom_range(adjusted_y1, adjusted_y2);
		for (var i = 0; i < array_length(hazards); i++) {
			if (point_distance(posX, posY, hazards[i].x, hazards[i].y) < dist) {
					validPosition = false;
					break;
			}
		}
	}
	
	healthBooster.x = posX;
	healthBooster.y = posY;
}

CreateRichochet = function(rm, hazards){
	var richochet = instance_create_layer((rm.x1 + rm.x2)/2 * CELL_SIZE, (rm.y1+rm.y2)/2 * CELL_SIZE, "Dungeon", oRichochet);
	var iter = 0;
	var dist = 64;
	var validPosition = false;
	var richochetWidth = sprite_get_width(richochet.sprite_index);
	var richochetHeight = sprite_get_height(richochet.sprite_index);
	var posX, posY;
	var adjusted_x1 = rm.x1 * CELL_SIZE;
	var adjusted_y1 = rm.y1 * CELL_SIZE;
	var adjusted_x2 = rm.x2 * CELL_SIZE - richochetWidth;
	var adjusted_y2 = rm.y2 * CELL_SIZE - richochetHeight;
	
	while(!validPosition && iter<50){
		validPosition = true;
		posX = irandom_range(adjusted_x1, adjusted_x2);
		posY = irandom_range(adjusted_y1, adjusted_y2);
		for (var i = 0; i < array_length(hazards); i++) {
			if (point_distance(posX, posY, hazards[i].x, hazards[i].y) < dist) {
					validPosition = false;
					break;
			}
		}
	}
	
	richochet.x = posX;
	richochet.y = posY;
}

CreateHazards = function(rm) {
	var _x1 = rm.x1;
	var _y1 = rm.y1;
	var _x2 = rm.x2;
	var _y2 = rm.y2;
	var hazardCount = irandom_range(1,3);
	var placedHazards = [];
	var hazardDistance = 128;
	var hallwayDistance = 64;
	for(var j = 0; j<hazardCount;j++){
		var hazard;
		var posX, posY;
		var validPosition = false;
		var size = random_range(2,3);
		hazard = instance_create_layer(0,0,"WallTile", obj_wall);
		var iter = 0;
		while(!validPosition && iter < 50){
			iter++;
			var hazard_width = sprite_get_width(hazard.sprite_index) * size;
			var hazard_height = sprite_get_height(hazard.sprite_index) * size;
			
			var adjusted_x1 = _x1 * CELL_SIZE + hallwayDistance;
	        var adjusted_y1 = _y1 * CELL_SIZE + hallwayDistance;
	        var adjusted_x2 = _x2 * CELL_SIZE - hazard_width - hallwayDistance;
	        var adjusted_y2 = _y2 * CELL_SIZE - hazard_height - hallwayDistance;
		
			var posX = irandom_range(adjusted_x1, adjusted_x2);
			var posY = irandom_range(adjusted_y1, adjusted_y2);
			
			validPosition = true;
			for (var i = 0; i < array_length(placedHazards); i++) {
				var placedHazard = placedHazards[i];
				if (point_distance(posX, posY, placedHazard.x, placedHazard.y) < hazardDistance) {
					validPosition = false;
					break;
				}
			}
			for (var i = 0;i < ds_list_size(rm.hallways);i++){
				var hallway = ds_list_find_value(rm.hallways, i);
				if(hallway.NorthSouth){
					if(posX >= hallway.x1 * CELL_SIZE - hazard_width && posX<= hallway.x2 * CELL_SIZE){
						if(rm.y2 == hallway.y2){
							if(hallway.y2 * CELL_SIZE - posY < hallwayDistance){
								validPosition = false;
							}
						}
						else{
							if(posY - hallway.y1 * CELL_SIZE < hallwayDistance){
								validPosition = false;
							}
						}
					}
				}
				else{
					if(posY >= hallway.y1 * CELL_SIZE - hazard_height && posY<= hallway.y2 * CELL_SIZE){
						if(rm.x2 == hallway.x2){
							if(hallway.x2 * CELL_SIZE - posX < hallwayDistance){
								validPosition = false;
							}
						}
						else{
							if(posX - hallway.x1 * CELL_SIZE < hallwayDistance){
								validPosition = false;
							}
						}
					}
				}
			}
		}
		if(validPosition)
		{
			hazard.x = posX;
			hazard.y = posY;
			hazard.image_xscale = size;
	        hazard.image_yscale = size;
			placedHazards[array_length(placedHazards)] = {x: posX, y: posY};
		}
		else{
			instance_destroy(hazard);
		}
	}
	return placedHazards;
}

CreateEnemies = function(_x1,_y1,_x2,_y2, hazards){
	var enemyCount = irandom_range(1 + currLevel div 3,2 + currLevel div 3);
	var placedEnemies = [];
	var enemyDistance = 64;
	var wallDistance = 64;
	for(var j = 0; j<enemyCount;j++){
		var enemyType = choose(oTracker, oTurret);
		
		if (currLevel > 30 || global.richochet) {
			enemyType = choose(oTracker, oTurret, oTrackShooter);
		}
		
		var enemy;
		var posX, posY;
		var validPosition = false;
		enemy = instance_create_layer(0,0,"Dungeon", enemyType);
		var iter = 0;
		
		while(!validPosition && iter < 50){
			iter++;
			var adjusted_x1 = _x1 * CELL_SIZE + wallDistance;
	        var adjusted_y1 = _y1 * CELL_SIZE + wallDistance;
	        var adjusted_x2 = _x2 * CELL_SIZE - sprite_get_width(enemy.sprite_index) - wallDistance;
	        var adjusted_y2 = _y2 * CELL_SIZE - sprite_get_height(enemy.sprite_index) - wallDistance;
		
			var posX = random_range(adjusted_x1, adjusted_x2);
			var posY = random_range(adjusted_y1, adjusted_y2);
			
			validPosition = true;
			for (var i = 0; i < array_length(placedEnemies); i++) {
				var placedEnemy = placedEnemies[i];
				if (point_distance(posX, posY, placedEnemy.x, placedEnemy.y) < enemyDistance) {
					validPosition = false;
					break;
				}
			}
			for (var i = 0; i < array_length(hazards); i++) {
				if (point_distance(posX, posY, hazards[i].x, hazards[i].y) < wallDistance) {
					validPosition = false;
					break;
				}
			}
			
		}
		if(validPosition)
		{
			enemy.x = posX;
			enemy.y = posY;
			placedEnemies[array_length(placedEnemies)] = {x: posX, y: posY};
		}
		else{
			instance_destroy(enemy);
		}
	}
	return placedEnemies;
}

GenerateNewDungeon();

