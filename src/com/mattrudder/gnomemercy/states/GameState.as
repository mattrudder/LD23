package com.mattrudder.gnomemercy.states 
{
	import com.mattrudder.gnomemercy.Assets;
	import com.mattrudder.gnomemercy.entity.*;
	import com.mattrudder.gnomemercy.Registry;
	import com.mattrudder.utils.MathUtils;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import mx.utils.StringUtil;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Particle;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import Playtomic.Log;
	
	public class GameState extends World
	{	
		public var player:Player;
		public var level:Level;
		
		public function get wave():int
		{
			return m_wave;
		}
		
		public function GameState()
		{
			Log.Play();
			
			m_hudHealth = new Image(Assets.HUD_HEALTH);
			m_hudKills = new Image(Assets.HUD_KILLS);
			
			c_enemyTypes[Bird] =
			{ 
				outside: true,
				fnUpdateSpawners: function(entities:Array, level:Level) : void {
					if (entities.length < m_wave * 2)
					{
						var spawnCount:uint = MathUtils.randomRange(3, 5);
						for (var i:int = 0; i < spawnCount; i++) 
							level.spawnEnemy(Bird, true);
					}
				}
			};
			c_enemyTypes[Gopher] = 
			{
				outside: false,
				fnUpdateSpawners: function(entities:Array, level:Level) : void {
					if (entities.length < m_wave && FP.rand(100) > 75)
					{
						var spawnCount:uint = MathUtils.randomRange(2, 4);
						for (var i:int = 0; i < spawnCount; i++) 
							level.spawnEnemy(Gopher, false);
					}
				}
			};
			
			m_powerupTimer = new Timer(1500);
			m_powerupTimer.addEventListener(TimerEvent.TIMER, function (e:TimerEvent):void {
				randomSpawn();
			});
			
			m_powerupTimer.start();
			
			m_gameOverTimer = new Timer(5000, 1);
			m_gameOverTimer.addEventListener(TimerEvent.TIMER, function (e:TimerEvent):void {
				Log.LevelCounterMetric("game-over", m_wave);
				m_powerupTimer.stop();
				FP.world = new CreditsState();
			});
			
			m_gameStartTimer = new Timer(m_timeToStart * 1000, 1);
			m_gameStartTimer.addEventListener(TimerEvent.TIMER, function (e:TimerEvent):void {
				Registry.game.player.collidable = true;
			});
			
			Registry.game = this;
			
			level = new Level(Assets.MAP);
			add(level);
			
			level.spawnPlayer();
			level.spawnEnemy(Gopher, false);
		}
		
		private function randomSpawn():void
		{
			var kind:Class;
			if (FP.random * 100 > 20)
			{
				kind = FP.choose(Gopher, Bird);
				level.spawnEnemy(kind, c_enemyTypes[kind].outside);
			}
			else
			{
				kind = FP.choose(Toadstool, GasCan);
				if (!level.spawnPowerup(kind))
				{
					var t:Timer = new Timer(50, 1);
					t.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
						randomSpawn();
					});
				}
			}
		}

		override public function update():void 
		{
			if (m_firstFrame)
			{
				FP.setCamera(level.halfWidth - FP.halfHeight, level.halfHeight - FP.halfHeight);
				m_firstFrame = false;
			}
			
			processEnemySpawns();
			followPlayer(player.onCamera ? c_cameraSpeed : c_cameraSpeed * 2);
			
			if (player.health <= 0)
			{
				m_gameOverTimer.start();
			}
			
			// Make collidable the first from he's on camera.
			if (!Registry.game.player.collidable && Registry.game.player.onCamera)
			{	
				m_gameStartTimer.start();
			}
			
			super.update();
		}
		
		override public function render():void 
		{
			super.render();
			
			Draw.graphic(m_hudKills, FP.camera.x + FP.width - m_hudKills.width, FP.camera.y);
			Draw.graphic(m_hudHealth, FP.camera.x, FP.camera.y + FP.height - m_hudHealth.height);
			
			Draw.text("Kills: ", FP.camera.x + FP.width - m_hudKills.width + 22, FP.camera.y + 34, { size: 28, color: 0x000000, alpha: 0.6 } );
			Draw.text("Kills: ", FP.camera.x + FP.width - m_hudKills.width + 20, FP.camera.y + 32, { size: 28 } );
			
			Draw.text(m_kills.toString(), FP.camera.x + FP.width - m_hudKills.width / 2 + 14, FP.camera.y + 34, { size: 28, align: "center", color: 0x000000, alpha: 0.6, width: 50, resizable: true } );
			Draw.text(m_kills.toString(), FP.camera.x + FP.width - m_hudKills.width / 2 + 12, FP.camera.y + 32, { size: 28, align: "center", width: 50, resizable: true } );
			
			Draw.text(player.health.toString() + "%", FP.camera.x + 7, FP.camera.y + FP.height - m_hudHealth.height / 2 - 5, { size: 32, align: "center", color: 0x000000, alpha: 0.6, width: m_hudHealth.width } );
			Draw.text(player.health.toString() + "%", FP.camera.x + 5, FP.camera.y + FP.height - m_hudHealth.height / 2 - 7, { size: 32, align: "center", width: m_hudHealth.width } );
			
			if (m_gameOverTimer.running)
			{
				Draw.text("Gnome Over!", FP.camera.x + 2, FP.camera.y + FP.height / 2 - 92, { size: 96, align: "center", color: 0x000000, alpha: 0.6, width: FP.width } );
				Draw.text("Gnome Over!", FP.camera.x, FP.camera.y + FP.height / 2 - 96, { size: 96, align: "center", width: FP.width } );
			}
			
			if (m_gameStartTimer.running)
			{
				m_timeToStart -= FP.elapsed;
				var timeDisplay:String = m_timeToStart - 1 <= 0 ? "GO!" : int(m_timeToStart).toString() + "...";
				
				Draw.text(timeDisplay, FP.camera.x + 2, FP.camera.y + FP.height / 2 - 92, { size: 96, align: "center", color: 0x000000, alpha: 0.6, width: FP.width } );
				Draw.text(timeDisplay, FP.camera.x, FP.camera.y + FP.height / 2 - 96, { size: 96, align: "center", width: FP.width } );
			}
		}
		
		public function addKill():void 
		{
			m_kills++;
			m_killsRemaining--;
			if (m_killsRemaining <= 0)
			{
				m_wave++;
				m_killThisWave *= 2;
				m_killsRemaining = m_killThisWave;
				m_powerupTimer.delay -= 50;
			}
		}
		
		private function processEnemySpawns():void 
		{
			for (var key:Object in c_enemyTypes)
			{
				var obj:Object = c_enemyTypes[key];
				var enemyList:Array = [];
				getClass(key as Class, enemyList);
				obj.fnUpdateSpawners(enemyList, level);
			}
		}
		
		private function followPlayer(speed:int):void 
		{
			if (player == null)
				return;
				
			if (player.x - FP.camera.x < c_cameraOffset)
			{
				if (FP.camera.x > 0)
					FP.camera.x -= speed;
			}
			else if ((FP.camera.x + FP.width) - (player.x + player.width) < c_cameraOffset)
			{
				if (FP.camera.x + FP.width < level.width)
					FP.camera.x += speed;
			}
			
			if (player.y - FP.camera.y < c_cameraOffset)
			{
				if (FP.camera.y > 0)
					FP.camera.y -= speed;
			}
			else if ((FP.camera.y + FP.height) - (player.y + player.height) < c_cameraOffset)
			{
				if (FP.camera.y + FP.height < level.height)
					FP.camera.y += speed;
			}
		}
		
		private static const c_cameraOffset:int = 200;
		private static const c_cameraSpeed:int = 3;
		private static const c_enemyTypes:Dictionary = new Dictionary;
		private static const c_killsPerWave:int = 5;
		
		private var m_kills:int = 0;
		private var m_wave:int = 1;
		private var m_timeToStart:Number = 4;
		private var m_killThisWave:int = c_killsPerWave;
		private var m_killsRemaining:int = c_killsPerWave;
		private var m_powerupTimer:Timer;
		private var m_gameOverTimer:Timer;
		private var m_gameStartTimer:Timer;
		private var m_hudHealth:Image;
		private var m_hudKills:Image;
		private var m_firstFrame:Boolean = true;
	}
}