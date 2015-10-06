package
{
	import flash.events.Event;
	
	import map.TmpAnimal;
	import map.MapData;
	
	import z_spark.fallingsystem.Coor;
	import z_spark.fallingsystem.FConst;
	
	[SWF(frameRate=6o, width=1024, height=600)]
	public class FallingAsWill extends TestBase
	{
		
		private var nextFlag:Boolean;
		
		public function FallingAsWill()
		{
			super();
			m_map.gridData=MapData.roadArr0;
			m_fallingSys.setMapFallingRoad(MapData.roadArr0,MapData.startArr0);
			
			nextFlag=true;
			
		}
		
		private var c:uint=0;
		private var m_co:Coor=new Coor();
		override protected function onE(event:Event):void
		{
			if(nextFlag){
				
				var a:TmpAnimal=new TmpAnimal(0);
				animal_layer.addChild(a);
				var index:int=int(Math.random()*FConst.s_cols);
				m_co.index=index;
//				m_fallingSys.fill(a,m_co,true);
				
				nextFlag=false;
			}
			
			c++;
			if(c>10){
				c=0;
				nextFlag=true;
			}
			
			m_fallingSys.update();
		}
		
	}
}