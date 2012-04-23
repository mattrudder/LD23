package com.mattrudder.gnomemercy.entity 
{
	import com.mattrudder.gnomemercy.Assets;
	import com.mattrudder.gnomemercy.Registry;
	import com.mattrudder.gnomemercy.entity.Enemy;
	import com.mattrudder.utils.*;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Spritemap;
	
	public class Gopher extends Enemy 
	{
		public function Gopher(x:Number, y:Number)  
		{
			super(x, y, 1.0, 64, 64, Assets.GOPHER);

			sprite.add("burrowing", [0, 1], 8, true);
			sprite.add("walk-north", [4], 1, false);
			sprite.add("walk-north-idle", [4], 1, false);
			sprite.add("walk-side", [2], 1, false);
			sprite.add("walk-side-idle", [2], 1, false);
			sprite.add("walk-south", [3], 1, false);
			sprite.add("walk-south-idle", [3], 1, false);
			
			sprite.play("burrowing");
			
			layer = 3;
			
			gotoState(Burrowing);
		}
		
		override public function update():void 
		{
			super.update();
			
			var processCollisions:Boolean = true;
			switch (m_state)
			{
			case Burrowing:
				updateBurrow();
				processCollisions = false;
				break;
			case Chasing:
				updateChasing();
				break;
			case Idling:
				updateIdle();
				break;
			}

			if (processCollisions)
			{
				var hit:Entity = collide("projectile", x, y);
				if (hit)
				{
					if (m_state == Idling)
						die();

					world.remove(hit);
				}
			}
		}
		
		public function get state():uint
		{
			return m_state;
		}
		
		override public function render():void 
		{
			super.render();
		}
		
		private function gotoState(state:uint):void
		{
			switch (state)
			{
			case Burrowing:
				m_stateLength = MathUtils.randomRange(c_burrowMax);
				sprite.play("burrowing");
				break;
			case Chasing:
				m_stateLength = MathUtils.randomRange(c_chaseMax);
				m_speed = MathUtils.randomRange(Math.min(Registry.game.wave, c_speedMax), c_speedMin);
				m_direction = AnimUtils.getVectorToPlayer(x, y);
				break;
			case Idling:
				sprite.angle = 0;
				m_stateLength = MathUtils.randomRange(c_idleMax);
				break;
			}
			
			m_stateTime = 0;
			m_state = state;
		}
		
		private function updateChasing():void 
		{
			m_stateTime += FP.elapsed;
			if (m_stateTime < m_stateLength)
			{
				var dir:Vector3D = m_direction.clone();
				dir.scaleBy(m_speed);
				
				//if (Registry.game.player.collidable)
					tryMove(x + dir.x, y + dir.y)
			}
			else
			{
				gotoState(Idling);
			}
		}
		
		private function updateBurrow():void 
		{
			m_stateTime += FP.elapsed;
			if (m_stateTime >= m_stateLength)
			{
				gotoState(Chasing);
				
			}
		}
		
		private function updateIdle():void 
		{
			AnimUtils.playDirectionToPlayer(x, y, sprite);
			
			m_stateTime += FP.elapsed;
			if (m_stateTime >= m_stateLength)
			{
				gotoState(Burrowing);
			}
		}
		
		private static const c_burrowMax:Number = 1.5;
		private static const c_chaseMax:Number = 2;
		private static const c_idleMax:Number = 3;
		private static const c_speedMax:Number = 12;
		private static const c_speedMin:Number = 3;
		
		public static const Burrowing:Number = 0;
		public static const Chasing:Number = 1;
		public static const Idling:Number = 2;
		
		private var m_stateLength:Number = 0;
		private var m_stateTime:Number = 0;
		
		private var m_state:uint = Burrowing;
		private var m_direction:Vector3D = new Vector3D;
		private var m_speed:Number = 5;
	}

}