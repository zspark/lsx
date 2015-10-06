package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import map.MapBg;
	
	import z_spark.core.debug.DBGStats;
	import z_spark.fallingsystem.FallingSystem;
	
	public class TestBase extends Sprite
	{
		protected var m_intersection:Intersection;
		protected var m_fallingSys:FallingSystem;
		
		public function TestBase()
		{
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.color=0x000000;
			stage.frameRate=60;
			
			var fps:DBGStats=new DBGStats();
			fps.x=stage.stageWidth-60;
			addChild(fps);
			
			createLayer();
			map_layer.addChild(new MapBg());
			
			/////////////////////////////////////////////////////
			
			m_fallingSys=new FallingSystem();
			m_intersection=new Intersection(m_fallingSys);
			m_intersection.animal_layer=animal_layer;
			m_fallingSys.init(stage,m_intersection.map,m_intersection);
			m_fallingSys.startDebug(debug_layer);
			
		}
		
		
		public var map_layer:Sprite;
		public var debug_layer:Sprite;
		public var animal_layer:Sprite;
		private function createLayer():void
		{
			map_layer=new Sprite();
			addChild(map_layer);
			
			animal_layer=new Sprite();
			addChild(animal_layer);
			
			debug_layer=new Sprite();
			addChild(debug_layer);
		}
		
	}
}