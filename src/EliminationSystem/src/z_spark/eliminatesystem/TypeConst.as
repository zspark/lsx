package z_spark.eliminatesystem
{
	public class TypeConst
	{
		public static const NORMAL:uint=1;
		public static const LINE_UD:uint=3;
		public static const LINE_LR:uint=7;
		public static const BOOM:uint=15;
		public static const SUPER:uint=31;
		
		public static const TOTAL:Array=[NORMAL,LINE_LR,LINE_UD,BOOM,SUPER];
		
		public static const TWO_SUPER:int=SUPER*2;
		public static const SUPER_BOOM:int=SUPER+BOOM;
		public static const SUPER_LINELR:int=SUPER+LINE_LR;
		public static const SUPER_LINEUD:int=SUPER+LINE_UD;
		public static const SUPER_NORMAL:int=SUPER+NORMAL;
		public static const TWO_BOOM:int=BOOM*2;
		public static const BOOM_LINEUD:int=BOOM+LINE_UD;
		public static const BOOM_LINELR:int=BOOM+LINE_LR;
		public static const LINEUDLR:int=LINE_UD+LINE_LR;
		public static const TWO_LINEUD:int=LINE_UD+LINE_UD;
		public static const TWO_LINELR:int=LINE_LR+LINE_LR;
		
//		public static const LINE_UD_RED:uint=0x11;
//		public static const LINE_UD_GREEN:uint=0x12;
//		public static const LINE_UD_BLUE:uint=0x13;
//		public static const LINE_UD_PURPLE:uint=0x14;
//		public static const LINE_UD_YELLOW:uint=0x15;
//		
//		public static const LINE_LR_RED:uint=0x21;
//		public static const LINE_LR_GREEN:uint=0x22;
//		public static const LINE_LR_BLUE:uint=0x23;
//		public static const LINE_LR_PURPLE:uint=0x24;
//		public static const LINE_LR_YELLOW:uint=0x25;
//		
//		public static const CIRCLE_RED:uint=0x55;
//		public static const CIRCLE_GREEN:uint=0x55;
//		public static const CIRCLE_BLUE:uint=0x55;
//		public static const CIRCLE_PURPLE:uint=0x55;
//		public static const CIRCLE_YELLOW:uint=0x55;
//		
//		public static const SUPER_BIG:uint=0x100;
//		
//		
//		public static const ICE_0:uint=0x0100;
//		public static const ICE_1:uint=0x200;
//		public static const ICE_2:uint=0x300;
	}
}