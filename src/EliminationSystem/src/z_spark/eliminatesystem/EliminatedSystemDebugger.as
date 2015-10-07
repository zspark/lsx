package z_spark.eliminatesystem
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	import z_spark.core.utils.KeyboardConst;
	
	CONFIG::DEBUG{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import z_spark.core.utils.KeyboardConst;
	};

	internal final class EliminatedSystemDebugger
	{
		private var m_statusTxt:TextField;
		private var m_debugLayer:Sprite;
		private var m_stage:Stage;
		
		private static const INFO:String="w：改变选中动物的颜色；     t：改变选中动物的类型；";
		
		public function EliminatedSystemDebugger(stage:Stage,debugLayer:Sprite)
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
				m_statusTxt.y=m_stage.stageHeight-m_statusTxt.height-60;
				m_debugLayer.addChild(m_statusTxt);
			};
			
		}
		
		CONFIG::DEBUG
		private function onStageResize(event:Event):void
		{
			m_statusTxt.y=m_stage.stageHeight-m_statusTxt.height-60;
			m_statusTxt.width=m_stage.stageWidth;
		}
		
		CONFIG::DEBUG
		private function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case KeyboardConst.W:
				{
					changeColor();
					break;
				}
				case KeyboardConst.T:
				{
					changeType();
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
		private function changeColor():void{
			var exc:Exchange=EliminateSystem.s_ins.exchange;
			var entity:IEliminateEntity=exc.entityA;
			if(entity!=null){
				entity.color=getNextColor(entity.color);
			}
		}
		
		CONFIG::DEBUG
		private function getNextColor(curColor:uint):uint{
			var index:int=ColorConst.TOTAL.indexOf(curColor);
			index++;
			if(index>=ColorConst.TOTAL.length)index=0;
			return ColorConst.TOTAL[index];
		}
		
		CONFIG::DEBUG
		private function changeType():void{
			var exc:Exchange=EliminateSystem.s_ins.exchange;
			var entity:IEliminateEntity=exc.entityA;
			if(entity!=null){
				entity.type=getNextType(entity.type);
			}
		}
		
		CONFIG::DEBUG
		private function getNextType(curType:uint):uint{
			var index:int=TypeConst.TOTAL.indexOf(curType);
			index++;
			if(index>=TypeConst.TOTAL.length)index=0;
			return TypeConst.TOTAL[index];
		}
	}
}