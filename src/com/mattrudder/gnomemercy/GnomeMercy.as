package com.mattrudder.gnomemercy
{
	import com.mattrudder.gnomemercy.states.GameState;
	import flash.ui.Mouse;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Key;
	
	public class GnomeMercy extends Engine
	{
		public function GnomeMercy():void 
		{
			super(800, 600);
		}
		
		override public function init():void 
		{
			super.init();
			
			m_mouseHidden = true;
			
			FP.console.enable();
			FP.world = new GameState();
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		private var m_mouseHidden:Boolean;
	}
}