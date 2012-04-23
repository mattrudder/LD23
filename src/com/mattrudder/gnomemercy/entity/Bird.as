package com.mattrudder.gnomemercy.entity 
{
	import com.mattrudder.gnomemercy.Assets;
	import com.mattrudder.gnomemercy.Registry;
	import com.mattrudder.gnomemercy.entity.Enemy;
	import com.mattrudder.utils.AnimUtils;
	import com.mattrudder.utils.MathUtils;
	import flash.geom.Point;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Spritemap;
	
	public class Bird extends Enemy 
	{
		public function Bird(x:Number, y:Number) 
		{
			super(x, y, 0.75, 128, 128, Assets.BIRD);
			sprite.add("walk-north", [0, 1, 4, 1], 8, true);
			sprite.add("walk-north-idle", [1], 1, false);
			sprite.add("walk-side", [3, 7, 8, 7], 8, true);
			sprite.add("walk-side-idle", [7], 1, false);
			sprite.add("walk-south", [5, 2, 6, 2], 8, true);
			sprite.add("walk-south-idle", [2], 1, false);
			
			sprite.play("walk-south");
			layer = 1
			
			m_flightSpeed = MathUtils.randomRange(Math.min(Registry.game.wave, c_flightSpeedMax), 3);
		}
		
		override public function update():void 
		{
			super.update();
			
			AnimUtils.playDirectionToPlayer(x, y, sprite);
			
			var point:Point = FP.point;
			point.x = Registry.game.player.x - x;
			point.y = Registry.game.player.y - y;
			
			if (point.x * point.x + point.y * point.y > m_flightSpeed)
			{
				point.normalize(m_flightSpeed);
			}
			
			//if (Registry.game.player.collidable)
				tryMove(x + point.x, y + point.y);
			
			var hit:Entity = collide("projectile", x, y);
			if (hit)
			{
				die();
				world.remove(hit);
			}
		}
		
		private static const c_flightSpeedMax:uint = 10;
		
		private var m_flightSpeed:uint;
	}
}