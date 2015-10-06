package z_spark.attractionsystem
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import z_spark.batata.res.Res;
	import z_spark.batata.res.SubBitmapData;
	import z_spark.batata.ui.Movie;

	final public class Effector
	{
		private static var m_effectLayer:Sprite;
		
		public static function init(effetLayer:Sprite):void{
			m_effectLayer=effetLayer;
		}
		
		public static function playSound(name:String,loops:int=1):uint{
			return Res.playSound(name,loops);
		}
		
		public static function stopSound(id:uint):void{
			Res.stopSound(id);
		}
		
		public static function getBitmapData(name:String):SubBitmapData{
			return Res.getSubBitmapData(name);
		}
		
		public static function getProgramEffect(name:String,index:int,play:Boolean=false,iLoopMax:int=1):Movie{
			return null;
		}
		
		/**
		 *得到消除特效 
		 * @param name
		 * @param index
		 * @param play
		 * @param iLoopMax
		 * @return 
		 * 
		 */
		public static function getEliminateEffect(name:String,index:int,play:Boolean=false,iLoopMax:int=1):Movie{
			var movie:Movie;
			switch(name)
			{
				case EffectNameConst.EFT_ANIMAL_ELIMINATE:
				{
					movie=new Movie(3,"eliminate_",11,iLoopMax,1);
					break;
				}
				case EffectNameConst.EFT_BOOM_ELIMINATE:
				{
//					movie=new Movie(3,"eliminated_",11,iLoopMax,1);
					break;
				}
				case EffectNameConst.EFT_LINE_ELIMINATE:
				{
					movie=new Movie(3,"eliminate_line_",1,iLoopMax,1);
					break;
				}
				default:
				{
					break;
				}
			}
			
			if(movie){
				movie.middleAlign=true;
				movie.addEventListener(Event.COMPLETE,onPlayOver);
				addToDisList(movie,index);
				if(play)movie.play();
			}
			return movie;
		}
		
		public static function getGrowBigEffect(index:int,play:Boolean=false,iLoopMax:int=1):Movie{
			var movie:Movie=new Movie(4,"grow_big_",14,iLoopMax,1);
			movie.middleAlign=true;
			movie.addEventListener(Event.COMPLETE,onPlayOver);
			addToDisList(movie,index);
			if(play)movie.play();
			return movie;
		}
		
		public static function getSelectEffect(name:String,index:int,play:Boolean=true):Movie{
			var movie:Movie;
			switch(name)
			{
				case EffectNameConst.EFT_SELECT:
				{
					movie=new Movie(6,"select_",15,uint.MAX_VALUE,1);
					break;
				}
				default:
				{
					break;
				}
			}
			
			if(movie){
				movie.mouseChildren=false;
				movie.mouseEnabled=false;
				movie.middleAlign=true;
				addToDisList(movie,index);
				if(play)movie.play();
			}
			return movie;
		}
		
		public static function deleteEffectIns(mov:Movie):void{
			if(mov.parent && mov.parent == m_effectLayer){
				m_effectLayer.removeChild(mov);
				mov.dispose();
			}
		}
		
		public static function getArrowEffect(dir:String):Movie{
			var movie:Movie=new Movie(5,"arrow_",4,uint.MAX_VALUE,1);
			movie.middleAlign=true;
			m_effectLayer.addChild(movie);
			movie.play();
			if(dir=="up")movie.rotation=90;
			else if(dir=="down")movie.rotation=-90;
			else if(dir=="right")movie.rotation=180;
			else if(dir=="left")movie.rotation=0;
			return movie;
		}
		
		/**
		 *获取障碍物销毁特效； 
		 * @param name
		 * @param index
		 * @param play
		 * @param iLoopMax
		 * @return 
		 * 
		 */
		public static function getDestroyEffect(name:String,index:int,play:Boolean=false,iLoopMax:int=1):Movie{
			var movie:Movie;
			switch(name)
			{
				case EffectNameConst.EFT_BUBBLE_DESTROY:
				{
					movie=new Movie(3,"bubble_",11,iLoopMax,1);
					break;
				}
				case EffectNameConst.EFT_ICE_1_DESTROY:
				{
					movie=new Movie(8,"snow_1_",6,iLoopMax,0);
					break;
				}
				case EffectNameConst.EFT_ICE_2_DESTROY:
				{
					movie=new Movie(6,"snow_2_",11,iLoopMax,0);
					break;
				}
				default:
				{
					break;
				}
			}
			
			if(movie){
				movie.middleAlign=true;
				movie.addEventListener(Event.COMPLETE,onPlayOver);
				addToDisList(movie,index);
				if(play)movie.play();
			}
			return movie;
		}
		
		private static function onPlayOver(event:Event):void
		{
			var movie:Movie=event.currentTarget as Movie;
			if(movie){
				m_effectLayer.removeChild(movie);
				movie.dispose();
			}
		}
		
		private static function addToDisList(dis:DisplayObject,index:int):void{
			dis.x=((index%AConst.s_cols)+.5)*AConst.s_gridw;
			dis.y=(int(index/AConst.s_cols)+.5)*AConst.s_gridh;
			m_effectLayer.addChild(dis);
		}
	}
}