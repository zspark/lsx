package
{
	import map.MapData;
	
	import z_spark.core.debug.ButtonDbg;
	
	[SWF(frameRate=6o, width=1024, height=600)]
	public class FallingSystemTest extends TestBase
	{
		public function FallingSystemTest(){
			super();
			
			var ROAD:Array=MapData.roadArr0;
			var START:Array=MapData.startArr0;
			m_fallingSys.setData(ROAD,START);
			
			var index:uint=0;
			for (var i:int=0;i<MapData.entityArr0.length;i++){
				index=MapData.entityArr0[i];
				m_intersection.createInitAnimal(index);
			}
			m_fallingSys.freezeNodes(MapData.blockArr0);
			m_fallingSys.refreshRelation();
			
			var btn:ButtonDbg;
			btn=new ButtonDbg("开始下落",function():void{m_intersection.fallingTest();},null);
			btn.x=760;
			btn.y=250;
			
			addChild(btn);
			
		}
		
		
	}
}