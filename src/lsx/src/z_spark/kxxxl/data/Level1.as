package z_spark.kxxxl.data
{
	internal final class Level1 extends LevelBase
	{
		public function Level1()
		{
			startArr=[2,3,5,6,10,13,16];
			entityArr=[
				10,19,28,37,
				02,11,20,29,38,47,
				03,12,21,30,39,48,57,
				13,22,31,40,49,58,67,
				05,14,23,32,41,50,59,
				06,15,24,33,42,51,
				16,25,34,43
			];
			blockArr=[];
			bubbleBlockArr=[];
			roadArr=[
				[10,19,28,37],
				[02,11,20,29,38,47],
				[03,12,21,30,39,48,57],
				[13,22,31,40,49,58,67],
				[05,14,23,32,41,50,59],
				[06,15,24,33,42,51],
				[16,25,34,43]
			];
		}
		
	}
}