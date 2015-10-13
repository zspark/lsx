package z_spark.kxxxl.data
{
	import z_spark.kxxxl.game.Intersection;
	import z_spark.mapsystem.BlockTypeConst;

	public class DataManager
	{
		private static var s_iSys:Intersection;
		private static var s_dataArr:Array;
		public static function init(intersection:Intersection):void{
			s_iSys=intersection;
			
			s_dataArr=[];
			s_dataArr[1]=Level1;
			s_dataArr[2]=Level2;
			s_dataArr[3]=Level3;
			s_dataArr[4]=Level4;
			s_dataArr[5]=Level5;
			s_dataArr[8]=Level8;
			s_dataArr[33]=Level33;
			s_dataArr[34]=Level34;
		}
		
		CONFIG::DEBUG{
			public static function get dataArr():Array{return s_dataArr;}
			public static function isLevelDataExist(level:int):Boolean{
				return s_dataArr[level]!=null;
			}
		};
		
		public static function setData(level:int):void{
			s_iSys.clean();
			
			var cls:Class=s_dataArr[level] as Class;
			var data:LevelBase=new cls();
			
			s_iSys.mapSys.setData(data.roadArr,data.startArr);
			s_iSys.eliminateSys.filterArr=data.startArr;
			s_iSys.fallingSys.setData(data.roadArr,data.startArr);
			
			var index:uint=0;
			for (var i:int=0;i<data.entityArr.length;i++){
				index=data.entityArr[i];
				s_iSys.createInitAnimal(index);
			}
			if(data.blockArr.length!=0)s_iSys.mapSys.createBlock(data.blockArr,BlockTypeConst.ICE);
			if(data.bubbleBlockArr.length!=0)s_iSys.mapSys.createBlock(data.bubbleBlockArr,BlockTypeConst.BUBBLE);
			if(data.fenceArr.length!=0)s_iSys.mapSys.createBlock(data.fenceArr,BlockTypeConst.FENCE_LR);
			
		}
	}
}