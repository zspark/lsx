package
{
	import flash.events.MouseEvent;
	
	import map.MapData;
	
	import z_spark.core.debug.ButtonDbg;
	import z_spark.fallingsystem.FCmp;
	import z_spark.fallingsystem.Node;
	import z_spark.fallingsystem.FPriority;
	import z_spark.mapsystem.MapTile;
	
	[SWF(frameRate=6o, width=1024, height=600)]
	public class TreeTesting extends TestBase
	{
		public function TreeTesting()
		{
			super();
			m_map.gridData=MapData.roadArr0;
			m_map.tileClickCB=tileClickHandler;
			m_fallingSys.setMapFallingRoad(MapData.roadArr0,MapData.startArr0);
			
			var btn:ButtonDbg;
			btn=new ButtonDbg("填充Cmp",function():void{fillCmp();},null);
			btn.x=760;
			btn.y=250;
			addChild(btn);
			btn=new ButtonDbg("移除Cmp",function():void{removeCmp();},null);
			btn.x=760;
			btn.y=300;
			addChild(btn);
			
			btn=new ButtonDbg("freezeTile",function():void{freezeTile();},null);
			btn.x=760;
			btn.y=350;
			addChild(btn);
			
			btn=new ButtonDbg("meltTile",function():void{meltTile();},null);
			btn.x=760;
			btn.y=400;
			addChild(btn);
		}
		
		private function removeCmp():void
		{
			for each(var node:Node in tree.dbg_nodeMap){
				if(node==null)continue;
				node.cmp=null;
			}
		}
		
		private function fillCmp():void{
			for each(var node:Node in tree.dbg_nodeMap){
				if(node==null)continue;
				node.cmp=new FCmp();
			}
		}
		
		private var m_waitToFreezeArr:Array=[];
		private function tileClickHandler(tile:MapTile):void
		{
			if(tile.chosen){
				if(m_waitToFreezeArr.indexOf(tile.index)<0)
					m_waitToFreezeArr.push(tile.index);
			}else{
				if(m_waitToFreezeArr.indexOf(tile.index)>=0)
					m_waitToFreezeArr.splice(m_waitToFreezeArr.indexOf(tile.index),1);
			}
		}
		
		protected function freezeTile():void
		{
			tree.freezeNodes(m_waitToFreezeArr);
		}
		protected function meltTile():void
		{
			tree.meltNodes(m_waitToFreezeArr);
		}
		
		protected function breakChildrenNodesTest(event:MouseEvent):void
		{
			var tile:MapTile=event.currentTarget as MapTile;
			if(tile){
				var arr:Array=[]
				tree.breakChildrenNodes(tile.index,Node.MAX_CHILDREN,FPriority.ALL,arr);
				trace(arr);
			}
		}
		
		protected function breakElderNodeTest(event:MouseEvent):void
		{
			var tile:MapTile=event.currentTarget as MapTile;
			if(tile){
				tree.breakElderNode(tile.index,FPriority.SELF);
			}
		}
	}
}