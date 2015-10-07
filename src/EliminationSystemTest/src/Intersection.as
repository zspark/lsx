package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import z_spark.eliminatesystem.IEliminateEntity;
	import z_spark.eliminatesystem.IIntegrationSys_ES;
	import z_spark.kxxxlcore.GameSize;
	
	public class Intersection implements IIntegrationSys_ES
	{
		private var m_map:Array;
		public var m_layer:Sprite;
		public function Intersection()
		{
			GameSize.s_cols=10;
			GameSize.s_rows=10;
			m_map=new Array(GameSize.s_cols*GameSize.s_rows);
		}
		
		public function get map():Array{return m_map;}

		public function canExchange(indexA:int, indexB:int):Boolean
		{
			return true;
		}
		
		public function dispatchDisappearIndexes(arr:Array,playSound:Boolean):void
		{
			for each(var index:int in arr){
				var a:DisplayObject=m_map[index];
				if(a){
					a.parent.removeChild(a);
					m_map[index]=null;
				}
			}
		}
		
		public function createNewEffectAnimal(index:int, color:int, type:int):IEliminateEntity
		{
			var oldEntity:IEliminateEntity=m_map[index];
			if(oldEntity){
				m_layer.removeChild(oldEntity as DisplayObject);
			}
			var s:IEliminateEntity=new ESuperAnimal(index);
			s.color=color;
			s.type=type;
			m_map[index]=s;
			var dis:Sprite=s as Sprite;
			dis.x=(index%GameSize.s_cols)*GameSize.s_gridh+15;
			dis.y=int(index/GameSize.s_cols)*GameSize.s_gridw+15;
			m_layer.addChild(dis);
			return s;
		}
		
		public function get animalLayer():Sprite
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		
	}
}