package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import z_spark.fallingsystem.FConst;
	import z_spark.fallingsystem.IFallingEntity;
	
	public class FAnimal extends Sprite implements IFallingEntity
	{

		private var tf:TextField;
		public function FAnimal(idx:int)
		{
			var row:uint=int(idx/FConst.s_cols);
			var color:uint=0xFFFFFF-row*10;
			
			graphics.beginFill(color);
			var size:uint=FConst.s_gridw*.5-2;
			graphics.drawRect(-size,-size,size*2,size*2);
			graphics.endFill();
			
			tf=new TextField();
			tf.width=30;
			tf.height=30;
			tf.mouseEnabled=false;
			tf.text=idx+"";
			tf.multiline=false;
			tf.x=-size;
			tf.y=-size;
			
			addChild(tf);
		}
		
		private var _finishX:int;
		public function get finishX():int{return _finishX;}
		public function set finishX(value:int):void{_finishX=value;}
		
		private var _finishY:int;
		public function get finishY():int{return _finishY;}
		public function set finishY(value:int):void{_finishY=value;}
		
		private var _spdx:Number;
		public function get spdx():Number{return _spdx;	}
		public function set spdx(value:Number):void{_spdx=value;}
		
		private var _spdy:Number;
		public function get spdy():Number{return _spdy;	}
		public function set spdy(value:Number):void{_spdy=value;}
		
		private var _tmpx:Number;
		public function get tmpx():Number{return _tmpx;}
		public function set tmpx(value:Number):void{_tmpx=value;}
		
		private var _tmpy:Number;
		public function get tmpy():Number{return _tmpy;}
		public function set tmpy(value:Number):void{_tmpy=value;}
		
		public function render():void
		{
			this.x=_tmpx;
			this.y=_tmpy;
		}
		
		private var m_deep:int=0;
		public function get deep():int
		{
			// TODO Auto Generated method stub
			return m_deep;
		}
		
		public function set deep(value:int):void
		{
			m_deep=value;
			tf.text=value+'';
		}
		
	}
}