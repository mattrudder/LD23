package com.mattrudder.gnomemercy.states 
{
	import org.axgl.*;
	import org.axgl.render.*;
	import org.axgl.text.*;
	
	public class GameState extends AxState
	{	
		override public function create():void 
		{
			Ax.background = new AxColor(1.0, 0.3882352941176471, 0.2784313725490196);
			add(new AxText(10, 10, null, "Gnome Mercy"));
		}
		
		override public function update():void 
		{
			super.update();
		}
	}
}