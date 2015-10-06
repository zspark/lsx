package
{
	import flash.events.Event;
	
	import map.Animal;
	import map.MapTile;
	
	import z_spark.core.debug.ButtonDbg;
	
	[SWF(frameRate=6o, width=1024, height=600)]
	public class FallingAsWill extends TestBase
	{
		
		private var nextFlag:Boolean;
		
		public function FallingAsWill()
		{
			super();
			
			nextFlag=true;
			
			addEventListener(Event.ENTER_FRAME,onE);
			
			var btn:ButtonDbg=new ButtonDbg("加速",function():void{m_fallingSys.speed+=1},null);
			btn.x=650;
			btn.y=200;
			addChild(btn);
			
			btn=new ButtonDbg("减速",function():void{m_fallingSys.speed-=1},null);
			btn.x=650;
			btn.y=250;
			addChild(btn);
		}
		
		private var c:uint=0;
		protected function onE(event:Event):void
		{
			
			if(nextFlag){
				
				var a:Animal=new Animal(0);
				addChild(a);
				var tile:MapTile=m_map.getMapTile(0,int(Math.random()*COL));
				a.x=tile.x+15;
				a.y=tile.y+15;
				
				m_fallingSys.fill(a,false,true);
				
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