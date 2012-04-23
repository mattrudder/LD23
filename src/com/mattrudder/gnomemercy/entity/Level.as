package com.mattrudder.gnomemercy.entity 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import com.mattrudder.gnomemercy.Assets;
	import com.mattrudder.gnomemercy.Registry;
	import net.flashpunk.masks.Grid;
	
	public class Level extends Entity 
	{
		public function get collisionMap():Grid
		{
			return m_collisionGrid;
		}
		
		public function Level(data:Class)
		{
			var byteArray:ByteArray = new data();
			var xml:XML = new XML(byteArray.readUTFBytes(byteArray.length));
			var tilesList:String = xml.layer.data.toString();
			
			var solidTiles:Array = [];
			for each(var tile:XML in xml.tileset.tile)
			{
				for each(var prop:XML in tile.properties.property)
				{
					if (prop.@name == "collision" && prop.@value == "true")
						solidTiles.push(uint(tile.@id));
				}
			}
			
			var tiles:Tilemap = new Tilemap(Assets.TILES, xml.tileset.@tilewidth * xml.@width, xml.tileset.@tileheight * xml.@height, xml.tileset.@tilewidth, xml.tileset.@tileheight);			
			var grid:Grid = new Grid(tiles.width, tiles.height, tiles.tileWidth, tiles.tileHeight);
			loadFromString(tiles, grid, solidTiles, tilesList, ",", "\n");
			
			m_tiles = tiles;
			graphic = m_tiles;
			layer = 10;
			
			width = tiles.width;
			height = tiles.height;
			
			for each(var o:XML in xml.objectgroup.object)
			{
				var className:String = o.@type;
				switch (className)
				{
				case "PlayerStart":
					m_playerStarts.push(new PlayerStart(o.@x, o.@y));
					break;
				case "EnemySpawner":
					m_enemySpawners.push(new EnemySpawner(o.@x, o.@y));
					break;
				}
			}
			
			m_collisionGrid = grid;
			
			this.mask = m_collisionGrid;
			this.type = "solid";
			
			Registry.game.level = this;
		}
		
		private function loadFromString(tiles:Tilemap, grid:Grid, solid:Array, str:String, columnSep:String = ",", rowSep:String = "\n"):void
		{
			var u:Boolean = tiles.usePositions;
			tiles.usePositions = false;
			var row:Array = str.split(rowSep),
				rows:int = row.length,
				col:Array, cols:int, x:int, y:int;
			for (y = 0; y < rows; y ++)
			{
				if (row[y] == '') continue;
				col = row[y].split(columnSep),
				cols = col.length;
				for (x = 0; x < cols; x ++)
				{
					if (col[x] == '') continue;
					var value:uint = uint(col[x]) - 1;
					tiles.setTile(x, y, value);
					
					if (solid.indexOf(value) !== -1)
						grid.setTile(x, y, true);
				}
			}
			
			tiles.usePositions = u;
		}
		
		public function spawnPlayer():void
		{
			if (Registry.game.player == null)
			{
				var start:PlayerStart = getRandomObject(m_playerStarts) as PlayerStart;
				Registry.game.player = new Player(start.x, start.y);
				Registry.game.add(Registry.game.player);
			}
		}
		
		public function spawnEnemy(kind:Class, outsideCamera:Boolean):Boolean
		{
			if (Registry.game && Registry.game.player)
			{
				var start:EnemySpawner = getRandomObject(m_enemySpawners) as EnemySpawner;
				if (isInCamera(start.x, start.y) == outsideCamera || start.x < 0 || start.y < 0 || start.x > m_tiles.width || start.y > m_tiles.height)
					start = null;
				
				if (start != null)
				{
					var enemy:Entity = new kind(start.x, start.y) as Entity;
					if (enemy != null)
					{
						Registry.game.add(enemy);
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function spawnPowerup(kind:Class):Boolean 
		{
			if (Registry.game && Registry.game.player)
			{
				var start:EnemySpawner = getRandomObject(m_enemySpawners) as EnemySpawner;
				if (start.x < 0 || start.y < 0 || start.x > m_tiles.width || start.y > m_tiles.height)
					start = null;
				
				if (start != null)
				{
					var powerup:Entity = new kind(start.x, start.y) as Entity;
					if (powerup != null)
					{
						Registry.game.add(powerup);
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function isSolid(newX:Number, newY:Number):Boolean 
		{
			var tileX:uint = uint(newX / m_tiles.tileWidth);
			var tileY:uint = Math.floor(newY / m_tiles.tileHeight);
			
			return m_collisionGrid.getTile(tileX, tileY);
		}
		
		private function isInCamera(x:Number, y:Number):Boolean
		{
			return collideRect(x, y, Registry.game.camera.x, Registry.game.camera.y, FP.width, FP.height);
		}
		
		private function getRandomObject(arr:Array):Object
		{
			var obj:Object = null;
			while (obj == null)
			{
				obj = arr[FP.rand(arr.length)];
			}
			
			return obj;
		}
		
		private const c_tileWidth:Number = 32;
		private const c_tileHeight:Number = 32;
		
		private var m_tiles:Tilemap;
		private var m_playerStarts:Array = new Array();
		private var m_enemySpawners:Array = new Array();
		private var m_collisionGrid:Grid;
	}

}