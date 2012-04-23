package com.mattrudder.gnomemercy.entity 
{
	import com.mattrudder.gnomemercy.Assets;
	import com.mattrudder.gnomemercy.Registry;
	
	public class GasCan extends Powerup 
	{		
		public function GasCan(x:Number, y:Number) 
		{
			super(x, y, 10, Assets.GASCAN);
		}	
	}
}