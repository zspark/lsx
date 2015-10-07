package z_spark.kxxxl.animal
{
	import z_spark.eliminatesystem.ColorConst;
	import z_spark.eliminatesystem.TypeConst;

	internal final class AnimalUtil
	{
		public static function getSkin(color:uint,type:uint):String{
			var skin:String='super_normal_1';
			if(color==ColorConst.BLUE){
				if(type==TypeConst.NORMAL)skin="blue_normal_1";
				else if(type==TypeConst.BOOM)skin="blue_boom_1";
				else if(type==TypeConst.LINE_LR)skin="blue_line_1";
				else if(type==TypeConst.LINE_UD)skin="blue_line_1";
			}
			else if(color==ColorConst.GREEN){
				if(type==TypeConst.NORMAL)skin="green_normal_1";
				else if(type==TypeConst.BOOM)skin="green_boom_1";
				else if(type==TypeConst.LINE_LR)skin="green_line_1";
				else if(type==TypeConst.LINE_UD)skin="green_line_1";
			}
			else if(color==ColorConst.PURPLE){
				if(type==TypeConst.NORMAL)skin="purple_normal_1";
				else if(type==TypeConst.BOOM)skin="purple_boom_1";
				else if(type==TypeConst.LINE_LR)skin="purple_line_1";
				else if(type==TypeConst.LINE_UD)skin="purple_line_1";
			}
			else if(color==ColorConst.RED){
				if(type==TypeConst.NORMAL)skin="red_normal_1";
				else if(type==TypeConst.BOOM)skin="red_boom_1";
				else if(type==TypeConst.LINE_LR)skin="red_line_1";
				else if(type==TypeConst.LINE_UD)skin="red_line_1";
			}
			else if(color==ColorConst.YELLOW){
				if(type==TypeConst.NORMAL)skin="yellow_normal";
				else if(type==TypeConst.BOOM)skin="yellow_boom_1";
				else if(type==TypeConst.LINE_LR)skin="yellow_line_1";
				else if(type==TypeConst.LINE_UD)skin="yellow_line_1";
			}
			else if(color==ColorConst.GRAY){
				if(type==TypeConst.NORMAL)skin="gray_normal_1";
				else if(type==TypeConst.BOOM)skin="gray_boom_1";
				else if(type==TypeConst.LINE_LR)skin="gray_line_1";
				else if(type==TypeConst.LINE_UD)skin="gray_line_1";
			}
			else if(color==ColorConst.ALL)skin="super_normal_1";
			return skin;
		}
	}
}