package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import map.MapData;
	
	import z_spark.core.debug.ButtonDbg;
	import z_spark.fallingsystem.Coor;
	import z_spark.fallingsystem.FConst;
	import z_spark.mapsystem.Animal.MEntity;
	
	[SWF(frameRate=6o, width=1024, height=600)]
	public class Disappear extends TestBase
	{
		
		public function Disappear()
		{
			super();
			m_map.gridData=MapData.roadArr3;
			m_fallingSys.setMapFallingRoad(MapData.roadArr3,MapData.startArr3);
			
			var cmpArr:Array=[];
			var count:int=0;
			while(count<FConst.s_cols*FConst.s_rows){
				if(m_map.isGridExist2(count)){
					var a:MEntity=m_map.createAnimal();
//					a.addEventListener(MouseEvent.CLICK,onAClick);
					cmpArr.push(m_fallingSys.createFCmp_index(a,count));
				}
				count++;
			}
			m_fallingSys.fillWith(cmpArr);
			
			var btn:ButtonDbg;
			btn=new ButtonDbg("开始下落",function():void{fallingTest();},null);
			btn.x=760;
			btn.y=250;
			addChild(btn);
		}
		
		private function fallingTest():void
		{
			// TODO Auto Generated method stub
			m_fallingSys.disappear(m_fallingArr);
		}
		
		private var m_fallingArr:Array=[];
		protected function onAClick(event:MouseEvent):void
		{
			var a:MEntity=event.currentTarget as MEntity;
			if(a){
				var i:int=(int(a.y/FConst.s_gridh)*FConst.s_cols+int(a.x/FConst.s_gridw));
				var co:Coor=new Coor(i);
				animal_layer.removeChild(a);
				m_fallingArr.push(i);
			}
		}
		
		private var c:uint=0;
		private var m_co:Coor=new Coor();
		override protected function onE(event:Event):void
		{
			m_fallingSys.update();
		}
		
	}
}