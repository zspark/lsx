package z_spark.kxxxl.data
{
	public class GameData
	{
		private static const COLS:uint=10;
		private static const ROWS:uint=10;
		
		public static const startArr0:Array=[0,1,2,3,4,5,6,7,8,9];
		public static const entityArr0:Array=[
			0,1,2,3,4,5,6,7,8,9,
			10,11,12,13,14,15,16,17,18,19,
			20,21,22,23,24,25,26,27,28,29,
			30,31,32,34,35,36,37,38,39,
			43,44,46,47,48,49,
			50,51,52,53,54,55,56,57,58,59,
			60,61,62,63,64,65,66,67,68,69,
			70,71,72,73,74,75,76,77,78,79,
			80,81,82,83,84,85,86,87,88,89,
			90,91,92,93,94,95,96,97,98,99
		];
		public static const blockArr0:Array=[COLS*4,1+COLS*4,2+COLS*4,5+COLS*4];
		public static const roadArr0:Array=[
			[0,COLS,COLS*2,COLS*3,0+COLS*4,COLS*5,COLS*6,COLS*7,COLS*8,COLS*9,],
			[1,1+COLS,1+COLS*2,1+COLS*3,1+COLS*4,1+COLS*5,1+COLS*6,1+COLS*7,1+COLS*8,1+COLS*9],
			[2,2+COLS,2+COLS*2,2+COLS*3,2+COLS*4,2+COLS*5,2+COLS*6,2+COLS*7,2+COLS*8,2+COLS*9],
			[3,3+COLS,3+COLS*2],/*3+COLS*3,*/[3+COLS*4,3+COLS*5,3+COLS*6,3+COLS*7,3+COLS*8,3+COLS*9],
			[4,4+COLS,4+COLS*2,4+COLS*3,4+COLS*4,4+COLS*5,4+COLS*6,4+COLS*7,4+COLS*8,4+COLS*9],
			[5,5+COLS,5+COLS*2,5+COLS*3,5+COLS*4,5+COLS*5,5+COLS*6,5+COLS*7,5+COLS*8,5+COLS*9],
			[6,6+COLS,6+COLS*2,6+COLS*3,6+COLS*4,6+COLS*5,6+COLS*6,6+COLS*7,6+COLS*8,6+COLS*9],
			[7,7+COLS,7+COLS*2,7+COLS*3,7+COLS*4,7+COLS*5,7+COLS*6,7+COLS*7,7+COLS*8,7+COLS*9],
			[8,8+COLS,8+COLS*2,8+COLS*3,8+COLS*4,8+COLS*5,8+COLS*6,8+COLS*7,8+COLS*8,8+COLS*9],
			[9,9+COLS,9+COLS*2,9+COLS*3,9+COLS*4,9+COLS*5,9+COLS*6,9+COLS*7,9+COLS*8,9+COLS*9],
		];
		
		
		
	}
}



/*
public static const entityArr1:Array=[
0,09,18,27,36,45,54,63,72,81,
1,10,19,28,37,46,55,64,73,82,
2,11,20,29,38,47,56,65,74,83,
3,12,21,30,39,48,57,66,75,84,
4,13,22,31,40,49,58,67,76,85,
5,14,23,32,41,50,59,68,77,86,
6,15,24,33,42,51,60,69,78,87,
7,16,25,34,43,52,61,70,79,88,
8,17,26,35,44,53,62,71,80,89
];

public static const roadArr1:Array=[
	[0,9,18,27,36,45,54,63,72,81],
	[1,10,19,28,37,46,55,64,73,82],
	[2,11,20,29,38,47,56,65,74,83],
	[3,12,21,30,39,48,57,66,75,84],
	[4,13,22,31,40,49,58,67,76,85],
	[5,14,23,32,41,50,59,68,77,86],
	[6,15,24,33,42,51,60,69,78,87],
	[7,16,25,34,43,52,61,70,79,88],
	[8,17,26,35,44,53,62,71,80,89]
];*/