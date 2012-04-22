package com.mattrudder.gnomemercy 
{
	public class Assets 
	{
		[Embed(source = "/player.png")] public static const PLAYER:Class;
		[Embed(source = "/bird.png")] public static const BIRD:Class;
		
		[Embed(source = "/tiles.png")] public static const TILES:Class;
		[Embed(source = "/cursor.png")] public static const CURSOR:Class;
		
		[Embed(source = "/bullet.png")] public static const BULLET:Class;
		[Embed(source = "/lawn_dart.png")] public static const LAWNDART:Class;
		
		[Embed(source = "/testmap.tmx", mimeType="application/octet-stream")] public static const MAP:Class;
	}
}