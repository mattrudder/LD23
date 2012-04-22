package com.mattrudder.gnomemercy.entity 
{
	public class Enemy extends AnimatedEntity 
	{
		public function Enemy(x:Number, y:Number, scale:Number, spriteWidth:Number, spriteHeight:Number, sprite:Class) 
		{
			super(x, y, scale, spriteWidth, spriteHeight, sprite);
			this.type = "enemy";
		}
	}
}