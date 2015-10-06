package
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import z_spark.fallingsystem.FConst;
	import z_spark.fallingsystem.FUtil;
	import z_spark.fallingsystem.FallingSystem;
	import z_spark.fallingsystem.IFallingEntity;
	import z_spark.fallingsystem.IIntegrationSys_FS;
	
	public class Intersection implements IIntegrationSys_FS
	{
		public var animal_layer:DisplayObjectContainer;
		private var m_fallingSys:FallingSystem;
		private var m_map:Array;
		public function get map():Array{return m_map;}
		public function Intersection(fallSys:FallingSystem)
		{
			FConst.s_cols=10;
			FConst.s_rows=10;
			m_map=new Array(FConst.s_cols*FConst.s_rows);
			m_fallingSys=fallSys;
		}
		
		public function createInitAnimal(index:int):void
		{
			m_map[index]=createNewAnimal(index);
		}
		
		public function createNewAnimal(index:int):IFallingEntity
		{
			var a:IFallingEntity=new FAnimal(index);
			animal_layer.addChild(a as Sprite);
			m_fallingSys.refreshPosition(a,index);
			a.addEventListener(MouseEvent.CLICK,onAClick);
			return a;
		}
		
		public function standBy(arr:Array):void
		{
			trace("standBy");
			trace(arr);
		}
		
		public function fallingTest():void
		{
			m_fallingSys.disappear(m_fallingArr);
		}
		
		private var m_fallingArr:Array=[];
		protected function onAClick(event:MouseEvent):void
		{
			var a:IFallingEntity=event.currentTarget as IFallingEntity;
			if(a){
				animal_layer.removeChild(a as Sprite);
				a.removeEventListener(MouseEvent.CLICK,onAClick);
				var i:int=FUtil.convertToIndex(a.x,a.y);
				m_fallingArr.push(i);
				m_map[i]=null;
			}
		}
		
	}
}