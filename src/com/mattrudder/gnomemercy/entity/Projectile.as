package com.mattrudder.gnomemercy.entity 
{
	import net.flashpunk.masks.TransformedPixelmask;
	import flash.geom.Vector3D;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import com.mattrudder.gnomemercy.Registry;
	import com.mattrudder.gnomemercy.Assets;
	import com.mattrudder.utils.MathUtils;
	import net.flashpunk.masks.Pixelmask;
	
	public class Projectile extends AnimatedEntity
	{
		public static const PLAYER:uint = 0;
		public static const ENEMY:uint = 1;
		
		public function Projectile(x:Number, y:Number, angle:Number, speed:Number, faction:uint, scale:Number, spriteWidth:Number, spriteHeight:Number, sprite:Class) 
		{
			super(x, y, scale, spriteWidth, spriteHeight, sprite);
			this.faction = faction;
			this.type = "projectile";
			this.layer = 5;
			this.sprite.angle = angle - 90;
			
			m_speed = speed;
			m_velocity = MathUtils.AngleToVec(angle);
			m_velocity.scaleBy(speed);
			
			this.sprite.add("default", [0, 1], 4);
			this.sprite.play("default");
		}
		
		override public function update():void 
		{
			if (x < -width || x > Registry.game.level.width || y < -height || y > Registry.game.level.height)
				FP.world.remove(this);
				
			if (!tryMove(x + m_velocity.x * FP.elapsed, y - m_velocity.y * FP.elapsed) || collide("enemy", x, y))
				FP.world.remove(this);

				
			super.update();
		}
		
		public var faction:uint;
		
		private var m_velocity:Vector3D;
		private var m_speed:Number;
	}
}