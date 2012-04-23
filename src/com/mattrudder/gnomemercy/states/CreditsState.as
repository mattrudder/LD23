package com.mattrudder.gnomemercy.states 
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.*;
	import com.mattrudder.gnomemercy.Assets;
	import Playtomic.Log;
	
	public class CreditsState extends World 
	{
		public function CreditsState() 
		{
			addGraphic(new Image(Assets.CREDITS_SCREEN));
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.mousePressed)
				FP.world = new TitleState();
		}
	}
}