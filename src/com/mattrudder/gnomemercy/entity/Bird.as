package com.mattrudder.gnomemercy.entity 
{
	import com.mattrudder.gnomemercy.Assets;
	import com.mattrudder.gnomemercy.Registry;
	import com.mattrudder.gnomemercy.entity.Enemy;
	
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
		}
		
		override public function update():void 
		{
			super.update();
			
			moveTowards(Registry.game.player.x, Registry.game.player.y, 7);
			
			if (collide("projectile", x, y))
			{
				world.remove(this);
			}
		}
	}
}