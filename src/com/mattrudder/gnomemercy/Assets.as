package com.mattrudder.gnomemercy 
{
	public class Assets 
	{
		[Embed(source = "/player.png")] public static const PLAYER:Class;
		[Embed(source = "/bullet.png")] public static const BULLET:Class;
		[Embed(source = "/tiles.png")] public static const TILES:Class;
		[Embed(source = "/testmap.tmx", mimeType="application/octet-stream")] public static const MAP:Class;
	}
}