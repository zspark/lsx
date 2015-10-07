package z_spark.kxxxl.animal
{
	import z_spark.attractionsystem.Effector;
	import z_spark.batata.ui.Movie;
	import z_spark.eliminatesystem.IEliminateEntity;
	import z_spark.eliminatesystem.TypeConst;
	import z_spark.fallingsystem.IFallingEntity;
	import z_spark.kxxxlcore.GameSize;

	CONFIG::DEBUG{
	import flash.text.TextField;
	};
	
	
	public class Animal extends AnimalEntity implements IFallingEntity, IEliminateEntity
	{
		CONFIG::DEBUG{
			protected var m_tf:TextField;
			private var m_tfDeep:TextField;
			
		};
		
		private var m_arrow:Movie;
		private var m_arrow2:Movie;
		
		public function Animal()
		{
			super();
			CONFIG::DEBUG{
				m_tf=new TextField();
				m_tf.width=30;
				m_tf.height=30;
				m_tf.mouseEnabled=false;
				addChild(m_tf);
				m_tfDeep=new TextField();
				m_tfDeep.x=-15;
				m_tfDeep.y=-15;
				m_tfDeep.width=30;
				m_tfDeep.height=30;
				m_tfDeep.mouseEnabled=false;
				addChild(m_tfDeep);
			};
		}
		
		private var _finishX:int;
		public function get finishX():int{return _finishX;}
		public function set finishX(value:int):void{_finishX=value;}
		
		private var _finishY:int;
		public function get finishY():int{return _finishY;}
		public function set finishY(value:int):void{_finishY=value;}
		
		private var _spdx:Number;
		public function get spdx():Number{return _spdx;	}
		public function set spdx(value:Number):void{_spdx=value;}
		
		private var _spdy:Number;
		public function get spdy():Number{return _spdy;	}
		public function set spdy(value:Number):void{_spdy=value;}
		
		private var m_select:Boolean=false;
		public function set select(value:Boolean):void
		{
			m_select=value;
		}
		public function get select():Boolean{return m_select;}
		
		private var m_color:uint;
		public function get color():uint{return m_color;}
		public function set color(value:uint):void
		{
			m_color=value;
			if(m_type!=0x0){
				var skin:String=AnimalUtil.getSkin(m_color,m_type);
				setSkin(skin);
			}
			
			CONFIG::DEBUG{
				m_tf.text=value+'';
			};
		}
		
		private var m_type:uint=TypeConst.NORMAL;
		public function set type(value:uint):void{
			if(value==m_type)return;
			m_type=value;
			if(m_color!=0x0){
				var skin:String=AnimalUtil.getSkin(m_color,m_type);
				setSkin(skin);
			}
			
			if(m_arrow)m_arrow.dispose();
			if(m_arrow2)m_arrow2.dispose();
			switch(value)
			{
				case TypeConst.LINE_LR:
				{
					m_arrow=Effector.getArrowEffect("left");
					m_arrow.x=-int(GameSize.s_gridh*.5);
					addChild(m_arrow);
					m_arrow2=Effector.getArrowEffect("right");
					m_arrow2.x=int(GameSize.s_gridh*.5);
					addChild(m_arrow2);
					break;
				}	
				case TypeConst.LINE_UD:
				{
					m_arrow=Effector.getArrowEffect("up");
					m_arrow.y=-int(GameSize.s_gridw*.5);
					addChild(m_arrow);
					m_arrow2=Effector.getArrowEffect("down");
					m_arrow2.y=int(GameSize.s_gridw*.5);
					addChild(m_arrow2);
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		public function get type():uint{return m_type;}
		
		override public function destroy():void
		{
			super.destroy();
			if(m_arrow)m_arrow.dispose();
			if(m_arrow2)m_arrow2.dispose();
		}
	}
}