package com.mattrudder.gnomemercy.entity 
{
	public class EnemySpawner
	{
		public function get x():Number
		{
			return m_x;
		}
		
		public function get y():Number
		{
			return m_y;
		}
		
		public function EnemySpawner(x:Number, y:Number) 
		{
			m_x = x;
			m_y = y;
		}
		
		private var m_x:Number;
		private var m_y:Number;
	}
}