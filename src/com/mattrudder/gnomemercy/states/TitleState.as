package com.mattrudder.gnomemercy.states 
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.*;
	import com.mattrudder.gnomemercy.Assets;
	import Playtomic.Log;
	
	public class TitleState extends World 
	{
		public function TitleState() 
		{
			Log.View(7693, "fc12d4377fdb4bfe", "a57376143da047408ada1860b86aff", FP.engine.root.loaderInfo.loaderURL);
			
			addGraphic(new Image(Assets.TITLE_SCREEN));
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.mousePressed)
				FP.world = new ObjectiveState();
		}
	}
}