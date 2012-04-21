package com.mattrudder.gnomemercy.entity 
{
	import org.axgl.Ax;
	import org.axgl.AxGroup;
	import org.axgl.AxSprite;
	import com.mattrudder.gnomemercy.Assets;
	
	public class Bullet extends AxSprite 
	{
		public static const PLAYER:uint = 0;
		public static const ENEMY:uint = 1;
		
		public var faction:uint;
		
		public function Bullet(faction:uint) 
		{
			super(x, y, Assets.BULLET);
			this.faction = faction;
		}
		
		public function initialize(x:Number, y:Number, angle:Number, speed:Number):void
		{
			this.x = x - width / 2;
			this.y = y - height / 2;
			velocity.x = speed * Math.cos(angle);
			velocity.y = speed * Math.sin(angle);
		}
		
		override public function update():void 
		{
			if (x < -width || x > Ax.width || y < -height || y > Ax.height)
				destroy();
				
			super.update();
		}
		
		public static function create(x:Number, y:Number, angle:Number, speed:Number, faction:uint, group:AxGroup):Bullet
		{
			var bullet:Bullet = group.recycle() as Bullet;
			if (bullet == null)
			{
				bullet = new Bullet(faction);
				group.add(bullet);
			}
			
			bullet.initialize(x, y, angle, speed);
			return bullet;
		}
	}
}