package z_spark.kxxxl.game
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import z_spark.attractionsystem.Effector;
	import z_spark.batata.res.Res;
	import z_spark.core.debug.DBGStats;
	import z_spark.core.utils.KeyboardConst;
	import z_spark.core.utils.StageUtil;
	import z_spark.kxxxl.data.DataManager;

	public final class Game
	{
		private var m_stage:Stage;
		private var m_mapLayer:Sprite;
		private var m_blockLayer:Sprite;
		private var m_animalLayer:Sprite;
		private var m_effectLayer:Sprite;
		private var m_bgSoundId:uint;
		
		CONFIG::DEBUG{
			private var m_debugLayer:Sprite;
			private var m_currentLevel:int=3;
		};
		private var m_isc:Intersection;
		
		public function Game(stage:Stage)
		{
			m_stage=stage;
			
			initLayer();
			m_isc=new Intersection(10,9,70,70);
			m_isc.initLayer(m_mapLayer,m_blockLayer,m_animalLayer,m_effectLayer);
			m_isc.initSystem(m_stage);
			
			DataManager.init(m_isc);
			
			CONFIG::DEBUG{
				m_isc.fallingSys.startDebug(m_debugLayer);
				m_isc.mapSys.startDebug(stage,m_debugLayer);
				m_isc.eliminateSys.startDebug(stage,m_debugLayer);
				
				stage.addEventListener(Event.RESIZE,onR);
				function onR(event:Event):void
				{
					m_fps.x=stage.stageWidth-60;
				}
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN,onD);
				function onD(event:KeyboardEvent):void
				{
					if(event.keyCode==KeyboardConst.PERIOD){
						do{
							m_currentLevel++;
							if(m_currentLevel>=DataManager.dataArr.length)m_currentLevel=0;
						}while(!DataManager.isLevelDataExist(m_currentLevel));
						DataManager.setData(m_currentLevel);
					}else if(event.keyCode==KeyboardConst.COMMA){
						do{
							m_currentLevel--;
							if(m_currentLevel<0)m_currentLevel=DataManager.dataArr.length-1;
						}while(!DataManager.isLevelDataExist(m_currentLevel));
						DataManager.setData(m_currentLevel);
					}
				}
				
				var m_fps:DBGStats=new DBGStats();
				m_fps.x=stage.stageWidth-60;
				m_debugLayer.addChild(m_fps);
			};
			
			start();
		}
		
		private function start():void
		{
			DataManager.setData(m_currentLevel);
			
			CONFIG::DEBUG{return;};
			Effector.stopSound(m_bgSoundId);
			m_bgSoundId=Effector.playSound("sound_GameSceneBGM",99999);
		}		
		
		private function initLayer():void
		{
			var bg:Bitmap=Res.getBitmap("game_bg");
			bg.scaleX=StageUtil.sw/bg.width;
			bg.scaleY=StageUtil.sh/bg.height;
			m_stage.addChild(bg);
			m_mapLayer=new Sprite();
			m_stage.addChild(m_mapLayer);
			m_blockLayer=new Sprite();
			m_stage.addChild(m_blockLayer);
			m_animalLayer=new Sprite();
			m_stage.addChild(m_animalLayer);
			m_effectLayer=new Sprite();
			m_stage.addChild(m_effectLayer);
			
			CONFIG::DEBUG{
				m_debugLayer=new Sprite();
				m_stage.addChild(m_debugLayer);
			};
			
		}
		
	}
}