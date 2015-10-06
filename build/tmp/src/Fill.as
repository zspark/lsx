package
{
	import map.TmpAnimal;
	import map.MapData;
	
	import z_spark.fallingsystem.FConst;
	
	[SWF(frameRate=6o, width=1024, height=600)]
	public class Fill extends TestBase
	{
		
		public function Fill()
		{
			super();
			m_map.gridData=MapData.roadArr2;
			m_fallingSys.setMapFallingRoad(MapData.roadArr2,MapData.startArr0);
			
			/////////////////////////////////////////////////////////
			var count:uint=0;
			var cmpArr:Array=[];
			while(count<FConst.s_cols*FConst.s_rows){
				if(m_map.isGridExist2(count)){
					var a:TmpAnimal=new TmpAnimal(count);
					animal_layer.addChild(a);
					cmpArr.push(m_fallingSys.createFCmp_index(a,count));
				}
				count++;
			}
			m_fallingSys.fillWith(cmpArr);
			
			/*var btn:ButtonDbg=new ButtonDbg("加速",function():void{m_fallingSys.speed+=1},null);
			btn.x=650;
			btn.y=200;
			addChild(btn);
			
			btn=new ButtonDbg("减速",function():void{m_fallingSys.speed-=1},null);
			btn.x=650;
			btn.y=250;
			addChild(btn);*/
		}
		
		
	}
}