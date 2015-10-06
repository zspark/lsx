package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import map.MapControl;
	
	import z_spark.core.debug.DBGStats;
	import z_spark.fallingsystem.FallingSystem2;
	
	public class TestBase extends Sprite
	{
		protected var m_fallingSys:FallingSystem2;
		protected var m_map:MapControl;
		
		public const ROW:uint=20;
		public const COL:uint=20;
		
		public function TestBase()
		{
			trace("Hello World!");
			
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.color=0x000000;
			stage.frameRate=60;
			
			var fps:DBGStats=new DBGStats();
			fps.x=stage.stageWidth-60;
			addChild(fps);
			
			m_map=new MapControl(ROW,COL);
			addChild(m_map);
			m_fallingSys=new FallingSystem2(ROW,COL,30,30);
			m_fallingSys.mapData=m_map;
			
			
		}
	}
}