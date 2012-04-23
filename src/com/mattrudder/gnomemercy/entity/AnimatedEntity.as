package com.mattrudder.gnomemercy.entity 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.TransformedPixelmask;
	
	public class AnimatedEntity extends Entity 
	{
		public function get sprite():Spritemap
		{
			return m_sprite;
		}
		
		public function AnimatedEntity(x:Number, y:Number, scale:Number, spriteWidth:Number, spriteHeight:Number, sprite:Class) 
		{
			super(x, y);
			
			m_sprite = new Spritemap(sprite, spriteWidth, spriteHeight);
			m_sprite.scale = scale;
			
			this.graphic = m_sprite;
			this.layer = 5;
			this.mask = new TransformedPixelmask(m_sprite, m_sprite.scaledWidth / 2, m_sprite.scaledHeight / 2);
			
			
			//setHitbox(m_sprite.scaledWidth, m_sprite.scaledHeight);
		}
		
		private var m_sprite:Spritemap;
	}
}