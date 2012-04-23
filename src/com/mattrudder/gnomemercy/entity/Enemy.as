package com.mattrudder.gnomemercy.entity 
{
	import com.mattrudder.gnomemercy.Registry;
	
	public class Enemy extends AnimatedEntity 
	{
		public function Enemy(x:Number, y:Number, scale:Number, spriteWidth:Number, spriteHeight:Number, sprite:Class) 
		{
			super(x, y, scale, spriteWidth, spriteHeight, sprite);
			this.type = "enemy";
		}
		
		protected function die():void
		{
			Registry.game.addKill();
			world.remove(this);
		}
	}
}