package z_spark.mapsystem
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	
	import z_spark.kxxxlcore.GameSize;
	
	CONFIG::DEBUG{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import z_spark.core.utils.KeyboardConst;
	};

	internal final class MapSystemDebugger
	{
		private var m_statusTxt:TextField;
		private var m_debugLayer:Sprite;
		private var m_stage:Stage;
		private var m_visible:Boolean=true;
		
		private static const INFO:String="v：显示/隐藏静态动物；     m：打印动物信息";
		
		public function MapSystemDebugger(stage:Stage,debugLayer:Sprite)
		{
			CONFIG::DEBUG{
				m_stage=stage;
				m_debugLayer=debugLayer;
				
				m_stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyUp);
				m_stage.addEventListener(Event.RESIZE,onStageResize);
				
				m_statusTxt=new TextField();
				m_statusTxt.textColor=0xFFFFFF;
				m_statusTxt.mouseEnabled=false;
				m_statusTxt.multiline=true;
				m_statusTxt.width=m_stage.stageWidth;
				m_statusTxt.height=30;
				m_statusTxt.text=INFO;
				m_statusTxt.y=m_stage.stageHeight-m_statusTxt.height-30;
				m_debugLayer.addChild(m_statusTxt);
			};
		}
		
		CONFIG::DEBUG
		private function onStageResize(event:Event):void
		{
			m_statusTxt.y=m_stage.stageHeight-m_statusTxt.height-30;
			m_statusTxt.width=m_stage.stageWidth;
		}
		
		CONFIG::DEBUG
		private function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case KeyboardConst.V:
				{
					visibility(!m_visible);
					break;
				}
				case KeyboardConst.M:
				{
					printMap();
					break;
				}
				default:
				{
					break;
				}
			}
			m_statusTxt.text=INFO;
		}
		
		CONFIG::DEBUG
		private function visibility(value:Boolean):void{
			m_visible=value;
			for (var i:int=0;i<GameSize.s_rows;i++){
				for (var j:int=0;j<GameSize.s_cols;j++){
					var index:int=i*GameSize.s_cols+j;
					var entity:Sprite=MapSystem.s_ins.map[index];
					if(entity){
						entity.visible=m_visible;
					}
				}
			}
		}
		
		CONFIG::DEBUG
		private function printMap():void{
			var str:String='';
			for (var i:int=0;i<GameSize.s_rows;i++){
				for (var j:int=0;j<GameSize.s_cols;j++){
					var index:int=i*GameSize.s_cols+j;
					var entity:Object=MapSystem.s_ins.map[index];
					if(entity)
						str+=entity.color+"-"+entity.x+"-"+entity.y+',';
					else str+="X-X-X,";
				}
				str+='\n';
			}
			
			trace(str);
		}
	}
}