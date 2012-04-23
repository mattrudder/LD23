package com.mattrudder.gnomemercy.entity 
{
	import flash.display.BitmapData;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Pixelmask;
	import com.mattrudder.gnomemercy.Registry;

	public class Powerup extends Entity 
	{		
		public function Powerup(x:Number, y:Number, time:Number, sprite:Class) 
		{
			super(x, y)
			
			m_time = time;
			graphic = new Image(sprite);
			mask = new Pixelmask(sprite);
			layer = 4;
			type = "powerup";
		}
		
		public function get timeActive():Number
		{
			return m_time;
		}
		
		public function set timeActive(value:Number):void
		{
			m_time = value;
		}

		private var m_time:Number;
	}
}