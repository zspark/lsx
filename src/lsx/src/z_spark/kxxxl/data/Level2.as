package z_spark.kxxxl.data
{
	internal final class Level2 extends LevelBase
	{
		
		public function Level2(){
			startArr=[2,3];
			entityArr=[
				2,11,20,29,38,47,56,65,74,
				3,12,21,30,39,48,57,66,75,
				13,22,31,40,49,58,67,76,
				14,23,32,41,50,59,68,77
			];
			blockArr=[];
			bubbleBlockArr=[];
			roadArr=[
				[2,11,20,29,38,47,56,65,74,13,22,31,40,49,58,67,76,14,23,32,41,50,59,68,77],
				[3,12,21,30,39,48,57,66,75]
				
			];
		}
	}
}