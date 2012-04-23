package com.mattrudder.gnomemercy
{
	import com.mattrudder.gnomemercy.states.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.*;
	import flash.ui.Mouse;
	
	public class GnomeMercy extends Engine
	{
		public function GnomeMercy():void 
		{
			super(800, 600);
			
			Text.font = "Alice in Wonderland";
		}
		
		override public function init():void 
		{
			super.init();
			
			//FP.console.enable();
			FP.world = new TitleState();
		}
	}
}