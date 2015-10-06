package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import map.Animal;
	import map.MapTile;
	
	[SWF(frameRate=6o, width=1024, height=600)]
	public class Disappear extends TestBase
	{
		public function Disappear()
		{
			super();
			
			addEventListener(Event.ENTER_FRAME,onE);
			
			var A:int=0;
			for (var i:int=0;i<ROW-A;i++){
				for(var j:int=0;j<COL;j++){
					var tile:MapTile=m_map.getMapTile(i,j);
					if(tile==null)continue;
					
					var block:Boolean=Math.random()>.8;
					var a:Animal=new Animal(i*COL+j,block);
					a.x=tile.x;
					a.y=tile.y;
					if(!block)a.addEventListener(MouseEvent.CLICK,onC1);
					addChild(a);
					m_fallingSys.fill(a,block);
				}
			}
		}
		
		protected function onC2(event:MouseEvent):void
		{
			var obj:Animal=event.currentTarget as Animal;
			var row:uint=int(obj.y/30);
			var col:uint=int(obj.x/30);
			var index:uint=row*COL+col;
			
			trace(m_fallingSys.isContactToStart(index));
		}
		
		protected function onC1(event:MouseEvent):void
		{
			var obj:Animal=event.currentTarget as Animal;
			var row:uint=int(obj.y/30);
			var col:uint=int(obj.x/30);
			
			var index:uint=row*COL+col;
//			m_fallingSys.disappear([index,index+1,index-1]);
//			m_fallingSys.disappear([index,index+1/*,,index-1*/]);
			m_fallingSys.disappear([index]);
		}
		
		protected function onE(event:Event):void
		{
			m_fallingSys.update();
		}
		
	}
}