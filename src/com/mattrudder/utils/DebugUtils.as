package com.mattrudder.utils 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Matt Rudder
	 */
	public class DebugUtils 
	{
		public static function drawLine(data:BitmapData, x:int, y:int, x2:int, y2:int, color:uint):void
		{
			var shortLen:int = y2-y;
			var longLen:int = x2-x;
			if ((shortLen ^ (shortLen >> 31)) - (shortLen >> 31) > (longLen ^ (longLen >> 31)) - (longLen >> 31))
			{
				shortLen ^= longLen;
				longLen ^= shortLen;
				shortLen ^= longLen;

				var yLonger:Boolean = true;
			}
			else
			{
				yLonger = false;
			}

			var inc:int = longLen < 0 ? -1 : 1;

			var multDiff:Number = longLen == 0 ? shortLen : shortLen / longLen;

			if (yLonger) 
			{
				for (var i:int = 0; i != longLen; i += inc) 
				{
					data.setPixel(x + i*multDiff, y+i, color);
				}
			} 
			else 
			{
				for (i = 0; i != longLen; i += inc) 
				{
					data.setPixel(x+i, y+i*multDiff, color);
				}
			}
		}		
	}

}