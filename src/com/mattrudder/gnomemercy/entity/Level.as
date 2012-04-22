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
	
	public class Level extends Entity 
	{
		public function Level(data:Class)
		{
			var byteArray:ByteArray = new data();
			var xml:XML = new XML(byteArray.readUTFBytes(byteArray.length));
			var tilesList:String = xml.layer.data.toString();
			
			var tiles:Tilemap = new Tilemap(Assets.TILES, xml.tileset.@tilewidth * xml.@width, xml.tileset.@tileheight * xml.@height, xml.tileset.@tilewidth, xml.tileset.@tileheight);			
			tiles.loadFromString(tilesList, ",", "\n");
			
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
			
			Registry.game.level = this;
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
		
		public function spawnEnemy(kind:Class):void
		{
			if (Registry.game.player != null)
			{
				var start:EnemySpawner = null;
				while (start == null)
				{
					start = getRandomObject(m_enemySpawners) as EnemySpawner;
					if (isInCamera(start.x, start.y) || start.x < 0 || start.y < 0 || start.x > m_tiles.width || start.y > m_tiles.height)
						start = null;
				}
				
				var enemy:Entity = new kind(start.x, start.y) as Entity;
				if (enemy != null)
				{
					Registry.game.add(enemy);
				}
			}
		}
		
		private function isInCamera(x:Number, y:Number):Boolean
		{
			var viewport:Rectangle = new Rectangle(FP.camera.x, FP.camera.y, FP.width, FP.height);
			return viewport.contains(x, y);
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
	}

}