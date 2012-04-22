package com.mattrudder.gnomemercy.states 
{
	import com.mattrudder.gnomemercy.Assets;
	import com.mattrudder.gnomemercy.entity.Enemy;
	import com.mattrudder.gnomemercy.entity.Bird;
	import com.mattrudder.gnomemercy.entity.Level;
	import com.mattrudder.gnomemercy.entity.Player;
	import com.mattrudder.gnomemercy.Registry;
	import flash.utils.ByteArray;
	import mx.utils.StringUtil;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	
	public class GameState extends World
	{	
		public var player:Player;
		public var level:Level;
		
		public function GameState()
		{
			Registry.game = this;
			
			level = new Level(Assets.MAP);
			add(level);
			
			level.spawnPlayer();
			
			followPlayer(100000);
		}

		override public function update():void 
		{
			var enemyList:Array = [];
			getClass(Enemy, enemyList);
			if (enemyList.length == 0)
			{
				level.spawnEnemy(Bird);
				level.spawnEnemy(Bird);
				level.spawnEnemy(Bird);
				level.spawnEnemy(Bird);
			}
		
			followPlayer(c_cameraSpeed);
			super.update();
		}
		
		private function followPlayer(speed:int):void 
		{
			if (player == null)
				return;
				
			if (player.x - FP.camera.x < c_cameraOffset)
			{
				if (FP.camera.x > 0)
					FP.camera.x -= speed;
			}
			else if ((FP.camera.x + FP.width) - (player.x + player.width) < c_cameraOffset)
			{
				if (FP.camera.x + FP.width < level.width)
					FP.camera.x += speed;
			}
			
			if (player.y - FP.camera.y < c_cameraOffset)
			{
				if (FP.camera.y > 0)
					FP.camera.y -= speed;
			}
			else if ((FP.camera.y + FP.height) - (player.y + player.height) < c_cameraOffset)
			{
				if (FP.camera.y + FP.height < level.height)
					FP.camera.y += speed;
			}
		}
		
		private static const c_cameraOffset:int = 200;
		private static const c_cameraSpeed:int = 5;
	}
}