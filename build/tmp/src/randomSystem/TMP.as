package randomSystem
{
	import flash.display.DisplayObject;
	
	import z_spark.fallingsystem.Coor;
	import z_spark.fallingsystem.FCmp;
	import z_spark.fallingsystem.FallingSystem;
	import z_spark.fallingsystem.IMapSystem_FS;
	import z_spark.mapsystem.IFallingSystem;
	import z_spark.mapsystem.IRandomSystem;
	import z_spark.mapsystem.MapSystem;
	
	public class TMP implements IRandomSystem,IFallingSystem,IMapSystem_FS
	{
		
		private var m_mSys:MapSystem;
		private var m_fSys:FallingSystem;
		private var m_cmpArr:Array;
		public function TMP(mSys:MapSystem,fsys:FallingSystem)
		{
			m_mSys=mSys;
			m_fSys=fsys;
			
			m_cmpArr=[];
		}
		
		public function getRandom():int
		{
			return int(Math.random()*5)+1;
		}
		
		public function createFcmp(disobj:DisplayObject, index:int):void
		{
			var cmp:FCmp=m_fSys.createFCmp_index(disobj,index);
			m_cmpArr.push(cmp);
		}
		
		public function pushToFSystem():void
		{
			m_fSys.fillWith(m_cmpArr);
			m_cmpArr.length=0;
		}
		
		
		public function createNewAnimal():DisplayObject
		{
			return m_mSys.createAnimal();
		}
		
		public function isGridExist(row:uint, col:uint):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function isGridExist2(co:Coor):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function isGridExist3(index:int):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
	}
}