package com.mattrudder.gnomemercy.entity 
{
	import com.mattrudder.utils.DebugUtils;
	import com.mattrudder.utils.MathUtils;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import net.flashpunk.Entity;
	import mx.utils.StringUtil;
	import com.mattrudder.gnomemercy.Assets;
	import com.mattrudder.gnomemercy.Registry;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Player extends AnimatedEntity
	{
		public function get fire():Number
		{
			return BASE_FIRE;
		}
		
		public function Player(x:Number, y:Number) 
		{
			super(x, y, 0.3, 144, 252, Assets.PLAYER);
			sprite.add("walk-north", [0, 1, 2], 8, true);
			sprite.add("walk-north-idle", [1], 1, false);
			sprite.add("walk-side", [3, 4, 8, 4], 8, true);
			sprite.add("walk-side-idle", [4], 1, false);
			sprite.add("walk-south", [5, 6, 7, 6], 8, true);
			sprite.add("walk-south-idle", [6], 1, false);
			
			//setHitbox(sprite.scaledWidth, sprite.scaledHeight - 20, originX, originY - 20);

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
			
				
			var lines:Array = new Array(45, 225, 315, 135);
			
			//for (var i:int = 0; i < lines.length; i++) 
			//{
				//var angle:int = lines[i];
				//var line:Vector3D = MathUtils.AngleToVec(angle);
				//line.scaleBy(100);
				//Draw.linePlus(m_fireOrigin.x, m_fireOrigin.y, m_fireOrigin.x + line.x, m_fireOrigin.y - line.y, 0xFFFF0000, 1, 3);
				//Draw.text(angle.toString(), m_fireOrigin.x + line.x, m_fireOrigin.y + line.y);
			//}
		}
		
		override public function update():void 
		{
			super.update();
			
			m_movingFrame = false;
			m_fireOrigin = new Vector3D(x + width / 2, y + height / 2 + 20); 
			m_mouseDirection = FP.angle(m_fireOrigin.x, m_fireOrigin.y, world.mouseX, world.mouseY);
			
			if (m_mouseDirection >= 45 && m_mouseDirection <= 135) // north
			{
				m_direction = Direction.NORTH;
			}
			else if (m_mouseDirection >= 135 && m_mouseDirection <= 225) // west
			{
				m_direction = Direction.WEST;
				sprite.flipped = false;
			}
			else if (m_mouseDirection >= 225 && m_mouseDirection <= 315) // south
			{
				m_direction = Direction.SOUTH;
			}
			else // east
			{
				m_direction = Direction.EAST;
				sprite.flipped = true;
			}
			
			// DIRECTIONAL
			if (Input.check(Key.S)) // south
			{
				y += 250 * FP.elapsed;
				m_movingFrame = true;
			}
			else if (Input.check(Key.W)) // north
			{
				y -= 250 * FP.elapsed;
				m_movingFrame = true;
			}
			
			if (Input.check(Key.D)) // east
			{
				x += 250 * FP.elapsed;
				m_movingFrame = true;
			}
			else if (Input.check(Key.A)) // west
			{
				x -= 250 * FP.elapsed;
				m_movingFrame = true;
			}
			
			sprite.play(getAnimName());
			
			// WEAPONS
			if (Input.mouseDown && m_fireDelay <= 0)
			{
				shoot();
				m_fireDelay = fire;
			}
			
			m_fireDelay -= FP.elapsed;
		}
		
		private function getAnimName():String 
		{
			var animBaseName:String;
			switch (m_direction)
			{
			case Direction.NORTH:
				animBaseName = "walk-north";
				break;
			case Direction.SOUTH:
				animBaseName = "walk-south";
				break;
			case Direction.EAST:
			case Direction.WEST:
				animBaseName = "walk-side";
				break;
			default:
				return null;
			}
			
			FP.log(animBaseName + ": Dir = " + m_mouseDirection.toFixed());
			return m_movingFrame ? animBaseName : animBaseName + "-idle";
		}
		
		private function shoot():void
		{
			FP.world.add(LawnDart.create(m_fireOrigin.x + DIRECTION_XOFFSETS[m_direction], m_fireOrigin.y + DIRECTION_YOFFSETS[m_direction], m_mouseDirection, 750));
		}

		
		private static const BASE_FIRE:Number = 0.3;
		private static const DIRECTION_XOFFSETS:Array = new Array(0, 0, 0, 20, -40);
		private static const DIRECTION_YOFFSETS:Array = new Array(0, 20, 20, -20, 20);
		
		private var m_fireDelay:Number = 0;
		
		private var m_mouseDirection:Number;
		private var m_mouseCursor:Cursor;
		private var m_fireOrigin:Vector3D;
		private var m_direction:uint;
		private var m_movingFrame:Boolean;
	}
}