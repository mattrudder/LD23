package com.mattrudder.gnomemercy
{
	import com.mattrudder.gnomemercy.states.GameState;
	import org.axgl.Ax;
	
	
	public class GnomeMercy extends Ax 
	{
		public function GnomeMercy():void 
		{
			super(GameState);
		}
		
		override public function create():void 
		{
			Ax.debuggerEnabled = true;
		}
	}
}