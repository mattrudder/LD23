package com.mattrudder.gnomemercy.states 
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.*;
	import com.mattrudder.gnomemercy.Assets;
	import Playtomic.Log;
	
	public class ControlsState extends World 
	{
		public function ControlsState() 
		{	
			addGraphic(new Image(Assets.CONTROLS_SCREEN));
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.mousePressed)
				FP.world = new GameState();
		}
	}
}