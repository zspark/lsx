package
{
	import map.MapData;
	
	[SWF(frameRate=6o, width=1024, height=600)]
	public class MapSystemTest extends TestBase
	{
		
		public function MapSystemTest()
		{
			super();
			initData();
		}
		
		private function initData():void
		{
			m_fallingSys.setMapFallingRoad(MapData.roadArr0,MapData.startArr0);
			m_map.gridData=MapData.roadArr0;
			m_map.EntityData=MapData.entityArr0;
			
		}
		
	}
}