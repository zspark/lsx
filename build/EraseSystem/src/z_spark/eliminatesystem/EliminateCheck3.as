package z_spark.eliminatesystem
{
	import z_spark.attractionsystem.Effector;
	import z_spark.core.debug.logger.Logger;
	import z_spark.kxxxlcore.Assert;
	import z_spark.kxxxlcore.GameSize;

	/**
	 * version 3 
	 * @author z_Spark
	 * 
	 */
	final internal class EliminateCheck3
	{
		CONFIG::DEBUG{
			private static var s_log:Logger=Logger.getLog("EliminateCheck3");
		};
		private static var s_map:Array;
		private static var s_filterArr:Array=[];
		private static var s_genFn:Function;
		internal static function init(map:Array,genEffectAnimalFn:Function):void{
			s_map=map;
			s_genFn=genEffectAnimalFn;
		}
		
		public static function set filterArr(arr:Array):void{s_filterArr=arr;}
		
		public static function checkArray(arr:Array,eArr:Array,sEntities:Array):void{
			while(arr.length>0){
				var index:int=arr.shift();
				handleSingle(index,eArr,sEntities);
			}
		}
		
		public static function handleSingle(index:int,eArr:Array,sEntities:Array):void{
			if(s_filterArr.indexOf(index)>=0)return;
			
			var rowEliminateArr:Array=[];
			var rowCount:uint=checkRow(index,rowEliminateArr);
			var colEliminateArr:Array=[];
			var colCount:uint=checkCol(index,colEliminateArr);
			
			var result:int=s_genFn(rowEliminateArr,colEliminateArr,index);
			if(result>=0){
				var sIndex:int=rowEliminateArr.indexOf(result);
				if(sIndex>=0)rowEliminateArr.splice(sIndex,1);
				sIndex=colEliminateArr.indexOf(result);
				if(sIndex>=0)colEliminateArr.splice(sIndex,1);
			}
			
			if(rowCount>=3){
				for (var i:int=0;i<rowEliminateArr.length;i++){
					var idx:int=rowEliminateArr[i];
					pushToArr_index(idx,eArr);
					var entity:IEliminateEntity=getEntity_index(idx);
					if(entity){
						if(entity.type!=TypeConst.NORMAL){
							pushToSpecial_index(idx,sEntities);
						}
					}
				}
			}
			
			if(colCount>=3){
				for (i=0;i<colEliminateArr.length;i++){
					idx=colEliminateArr[i];
					pushToArr_index(idx,eArr);
					entity=getEntity_index(idx);
					if(entity){
						if(entity.type!=TypeConst.NORMAL){
							pushToSpecial_index(idx,sEntities);
						}
					}
				}
			}
		}
		
		public static function handleNormal(indexA:int,indexB:int,eArr:Array,sEntities:Array):void{
			handleSingle(indexA,eArr,sEntities);
			handleSingle(indexB,eArr,sEntities);
			
			var n:int=0;
			while(n<sEntities.length){
				var e:IEliminateEntity=sEntities[n];
				pushSpecial(e.index,eArr,sEntities);
				
				n++;
			}
		}
		
		/**
		 *处理组合消除，就是检查交换的2个都是特效动物的情况； 
		 * 前提是2个动物都必须存在; 
		 * @param indexa
		 * @param indexb
		 * @param eArr			该组合能消除的话，所有被涉及到的格子索引推入该数组；
		 * @param sEntities		该组合能消除的话，所有被涉及到的格子索引中包括特效鸟的entity推入该数组；
		 * @return 
		 * 
		 */
		public static function handleCombine(indexa:int,indexb:int,eArr:Array,sEntities:Array):int
		{
			CONFIG::DEBUG{
				s_log.info("::handleCombine(),indexa="+indexa+',indexb='+indexb);
			};
			var targetEntitya:IEliminateEntity=getEntity_index(indexa);
			if(targetEntitya==null)return 0;
			var targetEntityb:IEliminateEntity=getEntity_index(indexb);
			if(targetEntityb==null)return 0;
			
			var result:int=HandleResult.NO_COMBINE;
			var totalType:uint=targetEntitya.type+targetEntityb.type;
			switch(totalType)
			{
				case TypeConst.TWO_SUPER:
				{
					//全屏消除；
					pushAll(eArr);
					Effector.playSound("sound_swap_colorcolor_cleanAll");
					result=HandleResult.SUPER_NORMAL;
					break;
				}
				case TypeConst.SUPER_BOOM:
				{
					if(targetEntitya.type==TypeConst.SUPER){
						targetEntitya.color=targetEntityb.color;
						targetEntitya.type=TypeConst.NORMAL;
						pushSameColor(targetEntityb.color,eArr,sEntities);
						pushToArr_index(indexa,eArr);
						Effector.getGrowBigEffect(indexa,true,1);
					}else{
						targetEntityb.color=targetEntitya.color;
						targetEntityb.type=TypeConst.NORMAL;
						pushSameColor(targetEntitya.color,eArr,sEntities);
						pushToArr_index(indexb,eArr);
						Effector.getGrowBigEffect(indexb,true,1);
					}
					Effector.playSound("sound_swap_colorcolor_swap");
					result=HandleResult.SUPER_BOOM;
					break;
				}
				case TypeConst.SUPER_LINEUD:
				case TypeConst.SUPER_LINELR:
				{
					if(targetEntitya.type==TypeConst.SUPER){
						targetEntitya.color=targetEntityb.color;
						targetEntitya.type=TypeConst.NORMAL;
						pushSameColor(targetEntityb.color,eArr,sEntities);
						pushToArr_index(indexa,eArr);
						Effector.getGrowBigEffect(indexa,true,1);
					}else{
						targetEntityb.color=targetEntitya.color;
						targetEntityb.type=TypeConst.NORMAL;
						pushSameColor(targetEntitya.color,eArr,sEntities);
						pushToArr_index(indexb,eArr);
						Effector.getGrowBigEffect(indexb,true,1);
					}
					Effector.playSound("sound_swap_colorcolor_swap");
					result=HandleResult.SUPER_LINE;
					break;
				}
				case TypeConst.SUPER_NORMAL:
				{
					Effector.playSound("sound_swap_colorcolor_swap");
					if(targetEntitya.type==TypeConst.SUPER){
						pushSameColor(targetEntityb.color,eArr,sEntities);
						pushToArr_index(indexa,eArr);
						Effector.getGrowBigEffect(indexa,true,1);
					}else{
						pushSameColor(targetEntitya.color,eArr,sEntities);
						pushToArr_index(indexb,eArr);
						Effector.getGrowBigEffect(indexb,true,1);
					}
					result=HandleResult.SUPER_NORMAL;
					break;
				}
				case TypeConst.TWO_BOOM:
				{
					Effector.playSound("sound_swap_wrapwrap");
					pushCircle(indexa,3,eArr,sEntities);
					result=HandleResult.OTHER_COMBINE;
					break;
				}
				case TypeConst.BOOM_LINELR:
				{
					Effector.playSound("sound_swap_wrapline");
					pushBoomLineLR(indexa,indexb,eArr,sEntities);
					result=HandleResult.OTHER_COMBINE;
					break;
				}
				case TypeConst.BOOM_LINEUD:
				{
					Effector.playSound("sound_swap_wrapline");
					pushBoomLineUD(indexa,indexb,eArr,sEntities);
					result=HandleResult.OTHER_COMBINE;
					break;
				}
				case TypeConst.TWO_LINELR:
				{
					Effector.playSound("sound_swap_lineline");
					pushLineLR(indexa,eArr,sEntities);
					pushLineLR(indexb,eArr,sEntities);
					result=HandleResult.OTHER_COMBINE;
					break;
				}
				case TypeConst.TWO_LINEUD:
				{
					Effector.playSound("sound_swap_lineline");
					pushLineUD(indexa,eArr,sEntities);
					pushLineUD(indexb,eArr,sEntities);
					result=HandleResult.OTHER_COMBINE;
					break;
				}
				case TypeConst.LINEUDLR:
				{
					Effector.playSound("sound_swap_lineline");
					if(targetEntitya.type==TypeConst.LINE_LR){
						pushLineLR(indexa,eArr,sEntities);
						pushLineUD(indexb,eArr,sEntities);
					}else{
						pushLineUD(indexa,eArr,sEntities);
						pushLineLR(indexb,eArr,sEntities);
					}
					result=HandleResult.OTHER_COMBINE;
					break;
				}
				default:
					break;
			}
			return result;
		}
		
		/**
		 * 将index所在的特效鸟按照自己正常的范围消除后，将范围内的索引推入eArr，
		 * 这些索引中如果存在其他特效鸟，再次将实例推入sEntity中； 
		 * @param index
		 * @param eArr
		 * @param sEntities
		 * 
		 */
		public static function pushSpecial(index:int,eArr:Array,sEntities:Array):void{
			var entity:IEliminateEntity=s_map[index];
			CONFIG::DEBUG{
				Assert.AssertTrue(entity.type!=TypeConst.NORMAL);
			};
			if(entity){
				switch(entity.type)
				{
					case TypeConst.SUPER:
					{
						var color:int=ColorConst.TOTAL[int(ColorConst.TOTAL.length*Math.random())];
						pushSameColor(color,eArr,sEntities);
						Effector.playSound("sound_eliminate_color");
						break;
					}
					case TypeConst.BOOM:
					{
						pushCircle(index,2,eArr,sEntities);
						Effector.playSound("sound_eliminate_wrap");
						break;
					}
					case TypeConst.LINE_LR:
					{
						pushLineLR(index,eArr,sEntities);
						Effector.playSound("sound_eliminate_strip");
						break;
					}
					case TypeConst.LINE_UD:
					{
						pushLineUD(index,eArr,sEntities);
						Effector.playSound("sound_eliminate_strip");
						break;
					}
					default:
						break;
				}
			}
		}
		
		/**
		 *间接消除检测；
		 * @param arr
		 * 
		 */
//		private static function checkIndirectlyEliminate(specialEntityIndexes:Array,eArr:Array,sEntities:Array):void{
//			for(var i:int=0;i<specialEntityIndexes.length;i++){
//				var index:int=specialEntityIndexes[i];
//				handleIndirectlySpecialElimination(index,eArr,sEntities);
//			}
//		}
		
		/**
		 * 以index所在位置为圆心，radius为半径（格子数），将圆里面的entity推入arr中； 
		 * @param index
		 * @param radius
		 * 
		 */
		private static function pushCircle(index:int,radius:int,eArr:Array,sEntities:Array):void{
			var row:int=int(index/GameSize.s_cols);
			var col:int=index%GameSize.s_cols;
			const rsqr:int=radius*radius;
			for (var i:int=-radius;i<=radius;i++){
				for (var j:int=-radius;j<=radius;j++){
					if(i*i+j*j<=rsqr){
						pushToArr(row+i,col+j,eArr);
						var entity:IEliminateEntity=getEntity(row+i,col+j);
						if(entity && entity.type!=TypeConst.NORMAL){
							pushToSpecial(row+i,col+j,sEntities);
						}
					}
				}
			}
		}
		
		/**
		 * 将index所在行的全部索引推入arr中； 
		 * @param index
		 * @param arr
		 * 
		 */
		private static function pushLineLR(index:int,eArr:Array,sEntities:Array):void{
			var row:int=int(index/GameSize.s_cols);
			if(row<0 || row>=GameSize.s_rows)return;
			
			var i:int=0;
			while(i<GameSize.s_cols){
				pushToArr(row,i,eArr);
				var entity:IEliminateEntity=getEntity(row,i);
				if(entity && entity.type!=TypeConst.NORMAL){
					pushToSpecial(row,i,sEntities);
				}
				i++;
			}
			
			entity=s_map[index];
			sEntities.splice(sEntities.indexOf(entity),1);
		}
		
		/**
		 * 将index所在列的全部索引推入arr中； 
		 * @param index
		 * @param arr
		 * 
		 */
		private static function pushLineUD(index:int,eArr:Array,sEntities:Array):void{
			var col:int=index%GameSize.s_cols;
			var i:int=0;
			while(i<GameSize.s_rows){
				pushToArr(i,col,eArr);
				var entity:IEliminateEntity=getEntity(i,col);
				if(entity && entity.type!=TypeConst.NORMAL){
					pushToSpecial(i,col,sEntities);
				}
				i++;
			}
			
			entity=s_map[index];
			sEntities.splice(sEntities.indexOf(entity),1);
		}
		
		/**
		 *将indexa,indexb所在的行及其上下两行（共4行）推入arr中； 
		 * @param indexa
		 * @param indexb
		 * @param eArr
		 * @param sEntities
		 * 
		 */
		private static function pushBoomLineLR(indexa:int,indexb:int,eArr:Array,sEntities:Array):void{
			pushLineLR(indexa,eArr,sEntities);
			pushLineLR(indexb,eArr,sEntities);
			if(indexa==indexb+GameSize.s_cols){
				pushLineLR(indexa+GameSize.s_cols,eArr,sEntities);
				pushLineLR(indexb-GameSize.s_cols,eArr,sEntities);
			}else{
				pushLineLR(indexb+GameSize.s_cols,eArr,sEntities);
				pushLineLR(indexa-GameSize.s_cols,eArr,sEntities);
			}
			
			var entity:IEliminateEntity=s_map[indexa];
			sEntities.splice(sEntities.indexOf(entity),1);
			
			entity=s_map[indexb];
			sEntities.splice(sEntities.indexOf(entity),1);
		}
		
		/**
		 * 将indexa,indexb所在的列及其上下两列（共4列）推入arr中； 
		 * @param indexa
		 * @param indexb
		 * @param eArr
		 * @param sEntities
		 * 
		 */
		private static function pushBoomLineUD(indexa:int,indexb:int,eArr:Array,sEntities:Array):void{
			pushLineUD(indexa,eArr,sEntities);
			pushLineUD(indexb,eArr,sEntities);
			if(indexa==indexb+1){
				//b,a
				if((indexa%GameSize.s_cols)<GameSize.s_cols-1)pushLineUD(indexa+1,eArr,sEntities);
				if((indexb%GameSize.s_cols)>0)pushLineUD(indexb-1,eArr,sEntities);
			}else{
				//a,b
				if((indexb%GameSize.s_cols)<GameSize.s_cols-1)pushLineUD(indexb+1,eArr,sEntities);
				if((indexa%GameSize.s_cols)>0)pushLineUD(indexa-1,eArr,sEntities);
			}
			
			var entity:IEliminateEntity=s_map[indexa];
			sEntities.splice(sEntities.indexOf(entity),1);
			
			entity=s_map[indexb];
			sEntities.splice(sEntities.indexOf(entity),1);
		}
		
		/**
		 *将全屏中与color相同的动物推入eArr中 
		 * @param color
		 * @param eArr
		 * @param sEntities
		 * 
		 */
		private static function pushSameColor(color:uint,eArr:Array,sEntities:Array):void{
			for (var idx:int=0;idx<s_map.length;idx++){
				var entity:IEliminateEntity=getEntity_index(idx);
				if(entity){
					if(entity.color==color ){
						pushToArr_index(idx,eArr);
						if(entity.type!=TypeConst.NORMAL){
							pushToSpecial_index(idx,sEntities);
						}
					}
				}
			}
		}
		
		private static function pushAll(eArr:Array):void{
			for (var idx:int=0;idx<s_map.length;idx++){
				pushToArr_index(idx,eArr);
			}
		}
		
		/**
		 * 检查指定row。col下的entity颜色是否与指定color相同，相同的话推入arr中； 
		 * @param row
		 * @param col
		 * @param color
		 * @param arr
		 * @return 
		 * 
		 */
		private static function checkSameColor(row:int,col:int,color:uint,arr:Array):Boolean{
			var entity:IEliminateEntity=getEntity(row,col);
			if(entity && entity.color==color){
				pushToArr(row,col,arr);
				return true;
			}
			return false;
		}
		
		private static function getEntity(row:int,col:int):IEliminateEntity{
			if(row<0 || row>=GameSize.s_rows || col<0 ||col>=GameSize.s_cols)return null;
			var index:int=row*GameSize.s_cols+col;
			if(s_filterArr.indexOf(index)>=0)return null;
			return s_map[index] as IEliminateEntity;
		}
		
		private static function getEntity_index(index:int):IEliminateEntity{
			if(index<0 || index>=s_map.length ||s_filterArr.indexOf(index)>=0)return null;
			return s_map[index] as IEliminateEntity;
		}
		
		/**
		 * 检查index为中心，同一行内，将相连的相同颜色推入arr； 
		 * @param index
		 * @param arr
		 * @return 
		 * 
		 */
		private static function checkRow(index:int,arr:Array):int{
			//检查行
			var row:int=int(index/GameSize.s_cols);
			var col:int=index%GameSize.s_cols;
			var targetEntity:IEliminateEntity=getEntity_index(index);
			if(targetEntity){
				arr.push(index);
				var offset:int=0;
				do{
					offset++;
					var flag:Boolean=checkSameColor(row,col-offset,targetEntity.color,arr);
				}while(flag)
					
				offset=0;
				do{
					offset++;
					flag=checkSameColor(row,col+offset,targetEntity.color,arr);
				}while(flag)
					
			}
			return arr.length;
		}
		
		/**
		 * 检查index为中心，同一列内 将相连的相同颜色推入arr； 
		 * @param index
		 * @param arr
		 * @return 
		 * 
		 */
		private static function checkCol(index:int,arr:Array):int{
			//检查列
			var row:int=int(index/GameSize.s_cols);
			var col:int=index%GameSize.s_cols;
			var targetEntity:IEliminateEntity=s_map[index];
			if(targetEntity){
				arr.push(index);
				var offset:int=0;
				do{
					offset++;
					var flag:Boolean=checkSameColor(row-offset,col,targetEntity.color,arr);
				}while(flag)
				
				offset=0;
				do{
					offset++;
					flag=checkSameColor(row+offset,col,targetEntity.color,arr);
				}while(flag)
				
			}
			return arr.length;
		}
		
		
		/**
		 * 推入数组arr中，重复项不推入，不合法、合约定row、col不推入； 
		 * @param row
		 * @param col
		 * @param arr
		 * 
		 */
		private static function pushToArr(row:int,col:int,arr:Array):void{
			if(row<=0 || row>=GameSize.s_rows || col<0 || col>=GameSize.s_cols)return;
			var index:int=row*GameSize.s_cols+col;
			if(s_filterArr.indexOf(index)>=0)return;
			if(arr.indexOf(index)<0)arr.push(index);
		}
		
		private static function pushToArr_index(index:int,arr:Array):void{
			if(index<0 || index>=s_map.length)return;
			if(s_filterArr.indexOf(index)>=0)return;
			if(arr.indexOf(index)<0)arr.push(index);
		}
		
		private static function pushToSpecial(row:int,col:int,sEntities:Array):void{
			if(row<=0 || row>=GameSize.s_rows || col<0 || col>=GameSize.s_cols)return;
			var index:int=row*GameSize.s_cols+col;
			var entity:IEliminateEntity=s_map[index];
			if(entity && sEntities.indexOf(entity)<0)sEntities.push(entity);
		}
		
		private static function pushToSpecial_index(index:int,sEntities:Array):void{
			if(index<0 || index>=s_map.length)return;
			var entity:IEliminateEntity=s_map[index];
			if(entity && sEntities.indexOf(entity)<0)sEntities.push(entity);
		}
	}
}