package com.mattrudder.utils 
{
	import flash.geom.Vector3D;
	import net.flashpunk.FP;
	public class MathUtils 
	{		
		public static function DegToRad(x:Number):Number
		{
			return x * (Math.PI / 180);
		}
		
		public static function RadToDeg(x:Number):Number
		{
			return x * (180 / Math.PI);
		}
		
		public static function AngleToVec(x:Number):Vector3D
		{
			return RadToVec(DegToRad(x));
		}
		
		public static function RadToVec(x:Number):Vector3D
		{
			return new Vector3D(Math.cos(x), Math.sin(x), 0, 1);
		}
		
		public static function randomRange(max:Number, min:Number = 0):Number
		{
			return FP.random * (max - min) + min;
		}
	}
}