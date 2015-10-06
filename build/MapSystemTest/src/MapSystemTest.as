package
{
	import flash.display.Sprite;
	
	import map.MapData;
	
	import z_spark.mapsystem.MapSystem;
	
	[SWF(frameRate=6o, width=1024, height=600)]
	public class MapSystemTest extends Sprite
	{
		private var m_mapSystem:MapSystem;

		private var m_mapLayer:Sprite;
		private var m_blockLayer:Sprite;
		public function MapSystemTest()
		{
			super();
			m_mapSystem=new MapSystem();
			
			m_mapLayer=new Sprite();
			addChild(m_mapLayer);
			
			m_blockLayer=new Sprite();
			addChild(m_blockLayer);
			
			initData();
		}
		
		private function initData():void
		{
			m_mapSystem.mapLayer=m_mapLayer;
			m_mapSystem.blockLayer=m_blockLayer;
			m_mapSystem.gridData=MapData.roadArr0;
			m_mapSystem.blockData=MapData.blockArr0;
			
		}
		
	}
}