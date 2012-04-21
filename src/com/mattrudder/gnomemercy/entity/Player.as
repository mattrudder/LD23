package com.mattrudder.gnomemercy.entity 
{
	import com.mattrudder.gnomemercy.Assets;
	import com.mattrudder.gnomemercy.Registry;
	import org.axgl.Ax;
	import org.axgl.AxU;
	import org.axgl.input.AxKey;
	import org.axgl.input.AxMouseButton;
	
	public class Player extends Entity
	{
		private static const BASE_FIRE:Number = 0.3;
		
		public function get fire():Number {
			return BASE_FIRE;
		}
		
		public function Player(x:Number, y:Number) 
		{
			super(x, y);
			
			drag.x = drag.y = 600;
			
			load(Assets.PLAYER, 32, 32);
			addAnimation("idle", [0], 1, false);
			addAnimation("walk-north", [0], 1, false);
			addAnimation("walk-side", [1], 1, false);
			addAnimation("walk-south", [2], 1, false);
		}
		
		override public function update():void 
		{
			mouseDirection = AxU.getAngleToMouse(x, y);
			angle = mouseDirection * (180 / Math.PI);
			
			if (Ax.keys.down(AxKey.A))
			{
				acceleration.x = -850;
			}
			else if (Ax.keys.down(AxKey.D))
			{
				acceleration.x = 850;
			}
			else 
			{
				acceleration.x = 0;
			}
			
			acceleration.y = Ax.keys.down(AxKey.W) ? -850 : Ax.keys.down(AxKey.S) ? 850 : 0;
			
			if (angle < -35 && angle > -125)
			{
				animate("walk-north");
				angle += 90;
			}
			else if (angle > 45 && angle < 125)
			{
				animate("walk-south");
				angle -= 90;
			}
			else
			{
				animate("walk-side");
				angle += 180;
			}
			
			if (Ax.mouse.down(AxMouseButton.LEFT) && fireDelay <= 0)
			{
				shoot();
				fireDelay = fire;
			}
			
			fireDelay -= Ax.dt;
			
			super.update();
		}
		
		private function shoot():void
		{
			Bullet.create(x + width / 2, y + height / 2, mouseDirection, 500, Bullet.PLAYER, Registry.game.playerBullets);
		}
		
		private var mouseDirection:Number;
		
		private var fireDelay:Number = 0;
	}
}