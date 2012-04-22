package com.mattrudder.gnomemercy.entity 
{
	import com.mattrudder.gnomemercy.Assets;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
	public class Cursor extends Entity 
	{
		public function Cursor() 
		{
			var image:Image = new Image(Assets.CURSOR);
			width = image.width;
			height = image.height;
			
			graphic = image;
			layer = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			x = world.mouseX - width / 2;
			y = world.mouseY - height / 2;
		}
	}
}