package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import z_spark.eliminatesystem.ColorConst;
	import z_spark.eliminatesystem.IEliminateEntity;
	import z_spark.kxxxlcore.GameSize;
	
	public class EAnimal extends Sprite implements IEliminateEntity
	{
		private var m_color:uint;
		private var m_type:uint;
		private var tf:TextField;
		private var m_select:Boolean=false;
		public function get dir():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function set dir(value:int):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function EAnimal(idx:int)
		{
			super();
			var size:uint=GameSize.s_gridw*.5-2;
			tf=new TextField();
			tf.width=30;
			tf.height=30;
			tf.mouseEnabled=false;
			tf.multiline=false;
			tf.x=-size;
			tf.y=-size;
			addChild(tf);
		}
		
		public function set select(value:Boolean):void
		{
			m_select=value;
			tf.textColor=value?0xFFFFFF:0x000000;
		}
		
		public function get select():Boolean
		{
			return m_select;
		}
		
		
		public function get color():uint
		{
			return m_color;
		}
		
		public function set color(value:uint):void
		{
			m_color=value;
			
			var c:uint;
			if(value==ColorConst.BLUE)c=0x0000FF;
			else if(value==ColorConst.GREEN)c=0x00FF00;
			else if(value==ColorConst.PURPLE)c=0xFF00FF;
			else if(value==ColorConst.RED)c=0xFF0000;
			else if(value==ColorConst.YELLOW)c=0xFFFF00;
			else if(value==ColorConst.ALL)c=0x888888;
			
			
			graphics.beginFill(c);
			var size:uint=GameSize.s_gridw*.5-1;
			graphics.drawRect(-size,-size,size*2,size*2);
			graphics.endFill();
		}
		
		public function destroy():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get index():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function get occupiedIndex():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function set occupiedIndex(value:int):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function set type(value:uint):void
		{
			m_type=value;
			tf.text=m_type+"";
		}
		
		
		public function get type():uint
		{
			return m_type;
		}
		
	}
}