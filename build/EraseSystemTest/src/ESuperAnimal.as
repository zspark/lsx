package
{
	import z_spark.eliminatesystem.EConst;
	import z_spark.eliminatesystem.IEliminateEntity;
	import z_spark.eliminatesystem.TypeConst;
	
	public class ESuperAnimal extends EAnimal implements IEliminateEntity
	{
		
		public function ESuperAnimal(idx:int)
		{
			super(idx);
		}
		
		override public function set type(value:uint):void
		{
			super.type=value;
			
			var size:uint=EConst.s_gridw*.5-3;
			switch(value)
			{
				case TypeConst.BOOM:
				{
					graphics.lineStyle(3.0,0x000000);
					graphics.drawCircle(0,0,size);
					break;
				}
				case TypeConst.SUPER:
				{
					graphics.lineStyle(2,0x000000);
					graphics.drawCircle(0,0,size);
					graphics.beginFill(0xFFFFFF);
					graphics.drawCircle(0,0,size-5);
					break;
				}
				case TypeConst.LINE_LR:
				{
					graphics.lineStyle(3.0,0x000000);
					graphics.moveTo(-size,0);
					graphics.lineTo(size,0);
					break;
				}	
					
				case TypeConst.LINE_UD:
				{
					graphics.lineStyle(3.0,0x000000);
					graphics.moveTo(0,-size);
					graphics.lineTo(0,size);
					break;
				}
				default:
				{
					break;
				}
			}
			graphics.endFill();
		}
		
	}
}