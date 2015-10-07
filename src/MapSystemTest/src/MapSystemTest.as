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
			trace("hello world");
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
			m_mapSystem.init(null,MapData.blockArr0,null,m_mapLayer,m_blockLayer,null);
			
		}
		
	}
}