package com.mattrudder.utils 
{
	
	import flash.geom.Vector3D;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import com.mattrudder.gnomemercy.Registry;
	import com.mattrudder.gnomemercy.entity.Direction;
	
	public class AnimUtils 
	{
		public static function playDirectionToPlayer(x:Number, y:Number, sprite:Spritemap, moving:Boolean = true):void
		{
			var dir:uint = getDirectionToPlayer(x, y, sprite);
			playDirection(dir, moving, sprite);
		}
		
		public static function playDirection(dir:uint, moving:Boolean, sprite:Spritemap):void
		{
			sprite.play(getAnimName(dir, moving));
		}
		
		public static function getVectorInDirection(dir:uint):Vector3D
		{
			switch (dir)
			{
			case Direction.NORTH:
				return new Vector3D(0, -1, 0, 0);
			case Direction.SOUTH:
				return new Vector3D(0, 1, 0, 0);
			case Direction.EAST:
				return new Vector3D(1, 0, 0, 0);
			case Direction.WEST:
				return new Vector3D(-1, 0, 0, 0);
			}
			
			return new Vector3D();
		}
		
		public static function getVectorToPlayer(x:Number, y:Number):Vector3D
		{
			var pos:Vector3D = new Vector3D(x, y);
			var player:Vector3D = new Vector3D(Registry.game.player.x, Registry.game.player.y);
			
			pos = player.subtract(pos);
			pos.normalize();
			
			return pos;
		}
		
		public static function getDirectionToPlayer(x:Number, y:Number, sprite:Spritemap = null):uint
		{
			return getDirectionXY(x, y, Registry.game.player.x, Registry.game.player.y, sprite);
		}
		
		public static function getDirectionToMouseXY(x:Number, y:Number, sprite:Spritemap = null):uint
		{
			return getDirectionXY(x, y, FP.world.mouseX, FP.world.mouseY, sprite);
		}
		
		public static function getDirectionXY(x:Number, y:Number, x2:Number, y2:Number, sprite:Spritemap = null):uint
		{
			return getDirection(FP.angle(x, y, x2, y2), sprite);
		}
		
		public static function getDirection(angle:Number, sprite:Spritemap = null):uint
		{
			var dir:uint = Direction.NONE;
			if (angle >= 45 && angle <= 135) // north
			{
				dir = Direction.NORTH;
			}
			else if (angle >= 135 && angle <= 225) // west
			{
				dir = Direction.WEST;
				if (sprite)
					sprite.flipped = false;
			}
			else if (angle >= 225 && angle <= 315) // south
			{
				dir = Direction.SOUTH;
			}
			else // east
			{
				dir = Direction.EAST;
				if (sprite)
					sprite.flipped = true;
			}
			
			return dir;
		}
		
		public static function getAnimName(dir:uint, moving:Boolean):String 
		{
			var animBaseName:String;
			switch (dir)
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
			
			return moving ? animBaseName : animBaseName + "-idle";
		}
	}
}