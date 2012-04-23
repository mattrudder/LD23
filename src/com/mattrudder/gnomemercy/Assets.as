package com.mattrudder.gnomemercy 
{
	public class Assets 
	{
		[Embed(source = "/player.png")] public static const PLAYER:Class;
		[Embed(source = "/bird.png")] public static const BIRD:Class;
		[Embed(source = "/gopher.png")] public static const GOPHER:Class;
		
		[Embed(source = "/tiles.png")] public static const TILES:Class;
		[Embed(source = "/cursor.png")] public static const CURSOR:Class;
		
		[Embed(source = "/bullet.png")] public static const BULLET:Class;
		[Embed(source = "/lawn_dart.png")] public static const LAWNDART:Class;
		
		[Embed(source = "/can.png")] public static const GASCAN:Class;
		[Embed(source = "/toadstool.png")] public static const TOADSTOOL:Class;
		
		[Embed(source = "/hud-health.png")] public static const HUD_HEALTH:Class;
		[Embed(source = "/hud-kills.png")] public static const HUD_KILLS:Class;
		
		[Embed(source = "/credits.png")] public static const CREDITS_SCREEN:Class;
		[Embed(source = "/titlescreen.png")] public static const TITLE_SCREEN:Class;
		[Embed(source = "/objective.png")] public static const OBJECTIVE_SCREEN:Class;
		[Embed(source = "/controls.png")] public static const CONTROLS_SCREEN:Class;
		
		[Embed(source = "/testmap.tmx", mimeType = "application/octet-stream")] public static const MAP:Class;
		[Embed(source = "/alice.ttf", embedAsCFF = "false", fontFamily = "Alice in Wonderland")] public static const FONT:Class;
	}
}