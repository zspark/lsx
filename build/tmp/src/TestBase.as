package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import randomSystem.TMP;
	
	import z_spark.core.debug.ButtonDbg;
	import z_spark.core.debug.DBGStats;
	import z_spark.fallingsystem.FallingSystemDebugger;
	import z_spark.fallingsystem.NodeControl;
	import z_spark.fallingsystem.FallingSystem;
	import z_spark.mapsystem.MapSystem;
	
	public class TestBase extends Sprite
	{
		protected var tree:NodeControl=NodeControl.s_ins;
		protected var m_fallingSys:FallingSystem;
		protected var m_map:MapSystem;
		
		private var m_pause:Boolean=false;
		protected var m_fdebugger:FallingSystemDebugger;
		
		public var map_layer:Sprite;
		public var debug_layer:Sprite;
		public var animal_layer:Sprite;
		public function TestBase()
		{
			trace("Hello World!");
			
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.color=0x000000;
			stage.frameRate=60;
			
			createLayer();
			
			m_fallingSys=new FallingSystem();
			m_map=new MapSystem();
			var tmp:TMP=new TMP(m_map,m_fallingSys);
			m_fallingSys.iMapSys=tmp;
			m_map.iFallSys=tmp;
			m_map.iRandomSys=tmp;
			m_map.mapLayer=map_layer;
			m_map.animalLayer=animal_layer;
			
			addTestButton();
			
			setPause(false);
			
		}
		
		private function createLayer():void
		{
			var fps:DBGStats=new DBGStats();
			fps.x=stage.stageWidth-60;
			addChild(fps);
			
			map_layer=new Sprite();
			addChild(map_layer);
			
			animal_layer=new Sprite();
			addChild(animal_layer);
			
			debug_layer=new Sprite();
			addChild(debug_layer);
			
			var debugLayer:Sprite=new Sprite();
			debug_layer.addChild(debugLayer);
			m_fdebugger=new FallingSystemDebugger(debugLayer);
		}
		
		private function addTestButton():void
		{
			var btn:ButtonDbg=new ButtonDbg("加速",function():void{m_fallingSys.speed+=1},null);
			btn.x=650;
			btn.y=50;
			addChild(btn);
			
			btn=new ButtonDbg("减速",function():void{m_fallingSys.speed-=1},null);
			btn.x=650;
			btn.y=100;
			addChild(btn);
			
			btn=new ButtonDbg("暂停/开始",function():void{setPause(!m_pause);},null);
			btn.x=650;
			btn.y=150;
			addChild(btn);
			
			btn=new ButtonDbg("步进",function():void{onE(null)},null);
			btn.x=650;
			btn.y=200;
			addChild(btn);
			
			btn=new ButtonDbg("drawElder",function():void{m_fdebugger.debugDrawElder();},null);
			btn.x=650;
			btn.y=250;
			addChild(btn);
			
			btn=new ButtonDbg("drawChildren",function():void{m_fdebugger.debugDrawChildren();},null);
			btn.x=650;
			btn.y=300;
			addChild(btn);
			
			btn=new ButtonDbg("drawOther",function():void{m_fdebugger.debugDrawNode();},null);
			btn.x=650;
			btn.y=350;
			addChild(btn);
			
			btn=new ButtonDbg("drawAll",function():void{m_fdebugger.debugDraw();},null);
			btn.x=650;
			btn.y=400;
			addChild(btn);
		}
		
		private function setPause(value:Boolean):void
		{
			if(!value)addEventListener(Event.ENTER_FRAME,onE);
			else removeEventListener(Event.ENTER_FRAME,onE);
			
			m_pause=value;
		}

		protected function onE(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
	}
}