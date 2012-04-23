package com.mattrudder.gnomemercy.entity 
{
	import com.mattrudder.utils.*;
	import com.mattrudder.gnomemercy.*;
	import flash.geom.ColorTransform;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.utils.*;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import mx.utils.StringUtil;

	public class Player extends AnimatedEntity
	{
		public function get fire():Number
		{
			return BASE_FIRE;
		}
		
		public function get health():Number
		{
			return m_health;
		}
		
		public function get walkSpeed():Number
		{
			return m_currentWalkSpeed;
		}
		
		public function Player(x:Number, y:Number) 
		{
			super(x, y, 0.3, 144, 252, Assets.PLAYER);
			sprite.add("death", [6], 1, false);
			sprite.add("walk-north", [0, 1, 2], 8, true);
			sprite.add("walk-north-idle", [1], 1, false);
			sprite.add("walk-side", [4, 9, 5, 9], 8, true);
			sprite.add("walk-side-idle", [9], 1, false);
			sprite.add("walk-south", [3, 8, 7, 8], 8, true);
			sprite.add("walk-south-idle", [8], 1, false);
			
			collidable = false;

			m_mouseCursor = new Cursor();
		}
		
		override public function added():void 
		{
			super.added();
			
			world.add(m_mouseCursor);
		}
		
		override public function removed():void 
		{
			m_mouseCursor.world.remove(m_mouseCursor);
			
			super.removed();
		}
		
		override public function render():void 
		{
			super.render();
			
			if (m_fireOrigin == null)
				return;
		}
		
		override public function update():void 
		{
			super.update();
			
			var movingFrame:Boolean = false;
			
			if (health > 0)
			{
				m_fireOrigin = new Vector3D(x + halfWidth, y + halfHeight); 
				m_mouseDirection = FP.angle(m_fireOrigin.x, m_fireOrigin.y, world.mouseX + m_mouseCursor.halfWidth, world.mouseY + m_mouseCursor.halfHeight);
				
				m_currentWalkSpeed = BASE_WALK;
				for (var i:int = 0; i < m_powerups.length; i++) 
				{
					p = m_powerups[i] as Powerup;
					p.timeActive -= FP.elapsed;
					if (p.timeActive <= 0)
					{
						m_powerups.splice(i, 1);
						i--;
					}
					else
					{
						if (p is GasCan)
							m_currentWalkSpeed += c_gasCanBuff;
					}
					
				}
				
				// DIRECTIONAL
				var velX:Number = 0;
				var velY:Number = 0;
				if (Input.check(Key.S)) // south
				{
					velY = m_currentWalkSpeed;
					movingFrame = true;
				}
				else if (Input.check(Key.W)) // north
				{
					velY = -m_currentWalkSpeed;
					movingFrame = true;
				}
				
				if (Input.check(Key.D)) // east
				{
					velX = m_currentWalkSpeed;
					movingFrame = true;
				}
				else if (Input.check(Key.A)) // west
				{
					velX = -m_currentWalkSpeed;
					movingFrame = true;
				}
				
				velX *= FP.elapsed;
				velY *= FP.elapsed;
				
				if (velX != 0 && velY != 0)
				{
					velX = (velX * 0.7);
					velY = (velY * 0.7);
				}
				
				tryMove(x + velX, y + velY);
				
				var p:Powerup = collide("powerup", x, y) as Powerup;
				if (p)
				{
					if (p is Toadstool)
					{
						if (m_health < 100)
						{
							m_health += 25;
							if (m_health > 100)
								m_health = 100;
						}
					}
					else
					{
						addBuff(p);
					}
					
					world.remove(p);
				}
				
				m_direction = AnimUtils.getDirection(m_mouseDirection, sprite);
				AnimUtils.playDirection(m_direction, movingFrame, sprite);
				
				// WEAPONS
				if (Input.mouseDown && m_fireDelay <= 0)
				{
					shoot();
					m_fireDelay = fire;
				}
				
				m_fireDelay -= FP.elapsed;

				var e:Enemy = collide("enemy", x, y) as Enemy;
				if (collidable && e && m_health > 0)
				{
					var v:Vector3D = MathUtils.AngleToVec(FP.angle(x, y, e.x, e.y));
					tryMove(x + v.x * 60, y + v.y * 60);
					
					m_health -= 15;
					
					if (m_health <= 0)
					{
						m_health = 0;
						sprite.play("death");
					}
				}
				
			}
		}
		
		public function addBuff(p:Powerup):void 
		{
			m_powerups.push(p);
		}
		
		private function shoot():void
		{
			// HACK: Mega hacks inbound...
			FP.world.add(LawnDart.create(m_fireOrigin.x + DIRECTION_XOFFSETS[m_direction], m_fireOrigin.y + DIRECTION_YOFFSETS[m_direction], m_mouseDirection + DIRECTION_ANGLEOFFSETS[m_direction], 750));
		}

		
		private static const BASE_FIRE:Number = 0.5;
		private static const BASE_WALK:Number = 250;
		private static const c_gasCanBuff:Number = 100;
		
		private static const DIRECTION_XOFFSETS:Array = new Array(0, -20, 20, 40, -40);
		private static const DIRECTION_YOFFSETS:Array = new Array(0, -40, 20, -10, 30);
		private static const DIRECTION_ANGLEOFFSETS:Array = new Array(0, 5, 3, 5, 3);
		
		private var m_fireDelay:Number = 0;
		
		private var m_mouseDirection:Number;
		private var m_mouseCursor:Cursor;
		private var m_fireOrigin:Vector3D;
		private var m_direction:uint;
		private var m_powerups:Array = new Array;
		private var m_currentFireSpeed:Number;
		private var m_currentWalkSpeed:Number;
		private var m_health:Number = 100;
	}
}