package com.mattrudder.gnomemercy.entity 
{
	import com.mattrudder.gnomemercy.Assets;
	import com.mattrudder.utils.MathUtils;
	import flash.geom.Vector3D;

	public class LawnDart extends Projectile
	{
		public function LawnDart(x:Number, y:Number, angle:Number, speed:Number) 
		{
			super(x, y, angle, speed, PLAYER, 1.0, c_spriteWidth, c_spriteHeight, Assets.LAWNDART);
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		static public function create(x:Number, y:Number, angle:Number, speed:Number):LawnDart 
		{
			return new LawnDart(x, y, angle, speed);
		}
		
		private static const c_spriteWidth:int = 32;
		private static const c_spriteHeight:int = 32;
	}
}