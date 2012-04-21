package com.mattrudder.gnomemercy.entity 
{
	import org.axgl.AxSprite;
	import org.axgl.AxVector;
	
	public class Entity extends AxSprite
	{
		public function Entity(x:Number, y:Number, graphic:Class = null)
		{
			super(x, y, graphic);
			
			maxVelocity = new AxVector(150, 150);
		}	
	}
}