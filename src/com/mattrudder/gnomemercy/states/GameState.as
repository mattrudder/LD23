package com.mattrudder.gnomemercy.states 
{
	import com.mattrudder.gnomemercy.Assets;
	import com.mattrudder.gnomemercy.entity.Player;
	import com.mattrudder.gnomemercy.Registry;
	import flash.utils.ByteArray;
	import mx.utils.StringUtil;
	import org.axgl.*;
	import org.axgl.input.AxMouse;
	import org.axgl.render.*;
	import org.axgl.text.*;
	import org.axgl.tilemap.AxTilemap;
	
	public class GameState extends AxState
	{	
		public var player:Player;
		
		public var playerBullets:AxGroup = new AxGroup;
		
		override public function create():void 
		{
			Registry.game = this;
			
			loadMap();
			
			//Ax.background = new AxColor(1.0, 0.3882352941176471, 0.2784313725490196);
			Ax.background = new AxColor(0, 0, 0);
			add(new AxText(10, 10, null, "Gnome Mercy"));
			add(mouseLabel = new AxText(10, 20, null, "Mouse: (0, 0)"));
			
			
			add(playerBullets);
			
			add(player = new Player(50, 50));
			Registry.player = player;
			
			
		}
		
		override public function update():void 
		{
			mouseLabel.text = StringUtil.substitute("Mouse: ({0}, {1})    Mouse Angle: ({2})    Player Angle: ({3})", Ax.mouse.x.toFixed(2), Ax.mouse.y.toFixed(2), (AxU.getAngleToMouse(player.x, player.y) * (180 / Math.PI)).toFixed(2), player.angle.toFixed(2));
			super.update();
		}
		
		private function loadMap():void
		{
			var byteArray:ByteArray = new Assets.MAP();
			var data:XML = new XML(byteArray.readUTFBytes(byteArray.length));
			var tiles:String = data.layer.data.toString();
			
			var tilemap:AxTilemap = new AxTilemap();
			tilemap.build(tiles, Assets.TILES, data.tileset.@tilewidth, data.tileset.@tileheight);
			add(tilemap);
		}
		
		private var mouseLabel:AxText;
	}
}