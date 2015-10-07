package z_spark.fallingsystem
{
	import z_spark.kxxxlcore.Assert;
	import z_spark.kxxxlcore.GameSize;

	CONFIG::DEBUG{
		import z_spark.core.debug.logger.Logger;
	};

	internal final class NodeControl
	{
		CONFIG::DEBUG{
			private static var s_log:Logger=Logger.getLog("FNoteControl");
			public static var s_ins:NodeControl;
			public function get dbg_roots():Array{return m_roots}
			public function get dbg_nodeMap():Vector.<Node>{return m_nodeMap}
			public function get dbg_noElderNodes():Array{return m_noElderNodes}
			public function get dbg_frozenNodes():Array{return m_frozenNodes}
		};
		private var m_roots:Array;
		private var m_noElderNodes:Array;
		private var m_frozenNodes:Array;
		private var m_nodeMap:Vector.<Node>;
		private var m_map:Array;
		
		public function NodeControl()
		{
			m_noElderNodes=[];
			m_frozenNodes=[];
			CONFIG::DEBUG{s_ins=this;}
		}
		
		public function init(map:Array):void{
			m_map=map;
		}
		
		public function isRootNode(index:int):Boolean{
			return m_roots.indexOf(index)>=0;
		}
		
		public function isFrozenNode(index:int):Boolean{
			return m_frozenNodes.indexOf(index)>=0;
		}
		
		public function getNode(index:int):Node{
			return m_nodeMap[index] as Node;
		}
		
		public function meltNodes(indexsCopy:Array):void{
			var indexs:Array=indexsCopy.concat();
			indexs.sort(Array.NUMERIC);
			CONFIG::DEBUG{
				s_log.info("::meltNodes()，要解冻的节点：",indexs);
				var whileTimes:uint=0;
			};
			while(indexs.length>0){
				var index:int=indexs.shift();
				CONFIG::DEBUG{
					whileTimes++;
					s_log.info("::meltNodes()，循环次数：",whileTimes,"处理的节点：",index);
				};
				
				if(index>=GameSize.s_cols*GameSize.s_rows || index<0)continue;
				if(m_frozenNodes.indexOf(index)<0)continue;
				m_frozenNodes.splice(m_frozenNodes.indexOf(index),1);
				var me:Node=m_nodeMap[index];
				
				/*处理插入节点与原来父节点的连通性*/
				var elderNode:Node=me.elderNode;
				if(elderNode!=null){
					
					//如果原父节点在断开地方有了新的子节点；并且优先级没有这里的高，就让新的子节点断开与父节点的连接，并推入待处理数组；
					CONFIG::DEBUG{
						s_log.info("::meltNodes()，原父节点存在：",elderNode.index);
					};
					var siblingNode:Node=elderNode.childrenNodes[me.relationToElderNode];
					if(siblingNode && siblingNode.index!=index){
						//有了新的子节点；
						CONFIG::DEBUG{
							s_log.info("::meltNodes()，原父节点存在，并且有个新的子节点：",siblingNode.index);
						};
						if(FUtil.APriorityBiggerThanB(me,siblingNode)){
							CONFIG::DEBUG{
								s_log.info("::meltNodes()，但我的优先级高；");
							};
							//但我的优先级高；
							breakElderNode(siblingNode.index,FPriority.ALL);
							elderNode.childrenNodes[me.relationToElderNode]=me;
							if(m_noElderNodes.indexOf(index)>=0)
								m_noElderNodes.splice(m_noElderNodes.indexOf(index),1);
							fixDescendant(me);
							m_noElderNodes.push(siblingNode.index);
						}else{
							CONFIG::DEBUG{
								s_log.info("::meltNodes()，我的优先级低;");
							};
							//我的优先级低；
							breakElderNode(index,FPriority.SELF);
							m_noElderNodes.push(index);
						}
					}else{
						elderNode.childrenNodes[me.relationToElderNode]=me;
						if(m_noElderNodes.indexOf(index)>=0)
							m_noElderNodes.splice(m_noElderNodes.indexOf(index),1);
						fixDescendant(me);
					}
				}
					
				/*处理插入节点与原来子节点的连通性*/
				//三个孩子依次遍历；
				var childNode:Node;
				var relation:int=0;//var relationArr:Array=[FNode.SON,FNode.LEFT_NEPHEW,FNode.RIGHT_NEPHEW];
				while(relation<Relation.MAX_CHILDREN){
					childNode=me.childrenNodes[relation];
					if(childNode!=null){
						//子节点存在；
						if(relation<=childNode.relationToElderNode){
							//我的优先级高；
							breakElderNode(childNode.index,FPriority.ALL);
							childNode.elderNode=me;
							childNode.relationToElderNode=relation;
							if(m_map[childNode.index]==null){
								if(m_frozenNodes.indexOf(childNode.index)<0)
									me.childrenNodes[relation]=childNode;
							}
							if(m_noElderNodes.indexOf(childNode.index)>=0)
								m_noElderNodes.splice(m_noElderNodes.indexOf(childNode.index),1);
						}else{
							me.childrenNodes[relation]=null;
						}
					}
					relation++;
				}
				
			}
			tryConnToElder();
			trace();
		}
		
		public function freezeNodes(indexCopy:Array):void{
			var indexArr:Array=indexCopy.concat();
			indexArr.sort(Array.NUMERIC);
			CONFIG::DEBUG{
				s_log.info("::freezeNodes()，要冻结的节点：",indexArr);
				var whileTimes:uint=0;
			};
			while(indexArr.length>0){
				var index:int=indexArr.shift();
				CONFIG::DEBUG{
					whileTimes++;
					s_log.info("::freezeNodes()，循环次数：",whileTimes,"处理的节点：",index);
				};
				if(index>=GameSize.s_cols*GameSize.s_rows || index<0) continue;
				if(m_frozenNodes.indexOf(index)>=0)continue;
				m_frozenNodes.push(index);
				
				var me:Node=m_nodeMap[index];
				var childrenIndexs:Array=[];
				me.breakComingIns(childrenIndexs);
				//断开子节点的连接后，表示所有子节点不存在父节点，必须为他们尝试找到新的父节点；
				
				CONFIG::DEBUG{
					s_log.info("::freezeNodes()，无父节点为：",childrenIndexs);
				};
				for each(var childIdx:int in childrenIndexs){
					if(indexArr.indexOf(childIdx)<0){
						m_noElderNodes.push(childIdx);
					}
				}
			}
			tryConnToElder();
			trace();
		}
		
		/**
		 * 检查指定格子的叔叔格子的下落性； 
		 * row与col是指定的格子T，
		 * T的直系格子是个阻挡格；
		 * 这种情况下，T及其直系子孙的填充靠左右叔叔格子；
		 * |─────|─────|─────|<br>
		 * |uncle|Block|uncle|<br>
		 * |─────|─────|─────|<br>
		 * |     |   T |     |<br>
		 * |─────|─────|─────|<br>
		 * |─────|─────|─────|<br>
		 * 
		 */
		public function tryConnToElder():Array{
			CONFIG::DEBUG{
				s_log.info("::tryConnToElder()，当前无父节点：",m_noElderNodes);
				s_log.info("::tryConnToElder()，当前的冻结节点：",m_frozenNodes);
				var iterTimes:uint=0;
			};
			var filterElderArr:Array=m_frozenNodes.concat();
			var noElderNodes:Array=m_noElderNodes.concat();
			noElderNodes.sort(Array.NUMERIC);
			var result:Array=[];
			while(noElderNodes.length>0){
				var index:int=noElderNodes.shift();
				CONFIG::DEBUG{
					s_log.info("::tryConnToElder()，遍历次数：",++iterTimes);
				};
				
				var flag:Boolean=tryConnToFather(index,filterElderArr);
				if(!flag)flag=tryConnRight(index,filterElderArr);
				if(!flag)flag=tryConnLeft(index,filterElderArr);
				
				var me:Node=m_nodeMap[index];
				if(!flag ){
					CONFIG::DEBUG{
						s_log.info("::tryConnToElder()，节点",index,"没有成功找到长辈节点！有无entity存在：",m_map[index]);
					};
					if(m_map[index]==null){
						filterElderArr.push(index);
						
						var i:int=Relation.MAX_CHILDREN;
						while(--i>=0){
							var childNode:Node=me.childrenNodes[i];
							if(childNode!=null){
								if(childNode.elderNode==me || childNode.elderNode==null){
									breakElderNode(childNode.index,FPriority.SELF);
									noElderNodes.push(childNode.index);
								}
							}
						}
						noElderNodes.sort(Array.NUMERIC);
					}
				}else{
					CONFIG::DEBUG{
						s_log.info("::tryConnToElder()，节点",index,"成功找到长辈节点！长辈节点为：",me.elderNode.index);
					};
					if(m_noElderNodes.indexOf(index)>=0)
						m_noElderNodes.splice(m_noElderNodes.indexOf(index));
					
					result.push(index);
///					me.deep=me.elderNode.deep+1;
					
					//告诉自己的子孙节点；
					fixDescendant(me);
				}
			}
			return result;
		}
		
		private function fixChild(fnode:Node,childNode:Node,relation:uint):Boolean{
			if(childNode.elderNode && childNode.elderNode!=fnode){
				if(relation<childNode.relationToElderNode){
					breakElderNode(childNode.index,FPriority.ALL);
					childNode.elderNode=fnode;
					childNode.relationToElderNode=relation;
					///					childNode.deep=fnode.deep+1;
					if(m_map[childNode.index]==null)
						fixDescendant(childNode);
					else fnode.childrenNodes[relation]==null;
				}else{
					fnode.childrenNodes[relation]=null;
				}
			}else{
				childNode.elderNode=fnode;
				childNode.relationToElderNode=relation;
				///	childNode.deep=fnode.deep+1;
				if(m_map[childNode.index]==null)
					fixDescendant(childNode);
				else fnode.childrenNodes[relation]==null;
			}
			return true;
		}
		
		private function fixDescendant(rootNode:Node):void{
			
			var dNode:Node=rootNode.childrenNodes[Relation.SON];
			if(dNode){
				fixChild(rootNode,dNode,Relation.SON);
			}
			
			dNode=rootNode.childrenNodes[Relation.LEFT_NEPHEW];
			if(dNode){
				fixChild(rootNode,dNode,Relation.LEFT_NEPHEW);
			}
			
			dNode=rootNode.childrenNodes[Relation.RIGHT_NEPHEW];
			if(dNode){
				fixChild(rootNode,dNode,Relation.RIGHT_NEPHEW);
			}
			
		}
		
		private function tryConnToFather(index:int,filterElderArr:Array):Boolean{
			var upGridIndex:int=index-GameSize.s_cols;
			if(upGridIndex<0)return false;
			if(filterElderArr.indexOf(upGridIndex)>=0)return false;
			
			var me:Node=m_nodeMap[index];
			var upNode:Node=m_nodeMap[upGridIndex];
			if(upNode==null)return false;
			
			var logicSonNode:Node=upNode.childrenNodes[Relation.SON];
			if(logicSonNode!=null){
				//找到的视觉“父节点”有儿子节点；说明他在逻辑上已经有孩子了；这样的话不能连接；
				CONFIG::DEBUG{
					s_log.info("::tryConnToFather()，节点"+index+"的视觉父节点有自己的逻辑子节点，其逻辑子节点为：",logicSonNode.index);
				};
				if(logicSonNode.index==index){
					me.elderNode=upNode;
					me.relationToElderNode=Relation.SON;
					return true;
				}else return false;
			}else{
				me.elderNode=upNode;
				me.relationToElderNode=Relation.SON;
				upNode.childrenNodes[Relation.SON]=me;
				return true;
			}
		}
		
		private function tryConnRight(index:int,filterElderArr:Array):Boolean{
			var result:Boolean=tryRightElder(index,filterElderArr);
			if(!result)result=tryRightUp(index,filterElderArr);
			return result;
		}
		
		private function tryRightElder(index:int,filterElderArr:Array):Boolean{
			Assert.AssertTrue(index>=0 && index<GameSize.s_cols*GameSize.s_rows);
			if(!FUtil.isSameRow(index,index+1))return false;
			if(filterElderArr.indexOf(index+1)>=0)return false;
			
			var me:Node=m_nodeMap[index];
			var rightNode:Node=m_nodeMap[index+1];
			if(rightNode==null)return false;
			var rightElderNode:Node=rightNode.elderNode;
			if(rightElderNode==null)return false;
			else{
				if(rightElderNode.col<=rightNode.col){
					var rightElderLeftNephew:Node=rightElderNode.childrenNodes[Relation.LEFT_NEPHEW];
					if(rightElderLeftNephew!=null){
						CONFIG::DEBUG{
							s_log.info("::tryRightElder()，节点"+index+"的视觉右节点的逻辑父节存在左侄子节点，视觉右节点/逻辑父节点/左侄子节点为：",rightNode.index,rightElderNode.index,rightElderLeftNephew.index);
						};
						if(rightElderLeftNephew.index==index){
							me.elderNode=rightElderNode;
							me.relationToElderNode=Relation.LEFT_NEPHEW;
							return true;
						}else return false;
					}else{
						if(m_map[me.index]==null)rightElderNode.childrenNodes[Relation.LEFT_NEPHEW]=me;
						me.elderNode=rightElderNode;
						me.relationToElderNode=Relation.LEFT_NEPHEW;
						return true;
					}
				}else {
					CONFIG::DEBUG{
						s_log.info("::tryRightElder()，节点"+index+"的视觉右节点的逻辑父节点过于偏离，视觉右节点/逻辑父节点为：",rightNode.index,rightElderNode.index);
					};
					return false;
				}
			}
		}
		
		private function tryRightUp(index:int,filterElderArr:Array):Boolean{
			Assert.AssertTrue(index>=0 && index<GameSize.s_cols*GameSize.s_rows);
			if(!FUtil.isSameRow(index,index+1))return false;
			var rightUpIndex:int=index+1-GameSize.s_cols;
			if(rightUpIndex<0)return false;
			if(filterElderArr.indexOf(rightUpIndex)>=0)return false;
			
			var me:Node=m_nodeMap[index];
			var rightUpNode:Node=m_nodeMap[rightUpIndex];
			if(rightUpNode==null)return false;
			var rightUpLeftNephewNode:Node=rightUpNode.childrenNodes[Relation.LEFT_NEPHEW];
			if(rightUpLeftNephewNode!=null){
				CONFIG::DEBUG{
					s_log.info("::tryRightUp()，节点"+index+"的视觉右上节点存在左侄子节点，视觉右上节点/左侄子节点为：",rightUpNode.index,rightUpLeftNephewNode.index);
				};
				if(rightUpLeftNephewNode.index==index){
					me.elderNode=rightUpNode;
					me.relationToElderNode=Relation.LEFT_NEPHEW;
					return true;
				}else return false;
			}else{
				if(m_map[me.index]==null)rightUpNode.childrenNodes[Relation.LEFT_NEPHEW]=me;
				me.elderNode=rightUpNode;
				me.relationToElderNode=Relation.LEFT_NEPHEW;
				return true;
			}
		}
		
		private function tryConnLeft(index:int,filterElderArr:Array):Boolean{
			var result:Boolean=tryLeftElder(index,filterElderArr);
			if(!result)result=tryLeftUp(index,filterElderArr);
			return result;
		}
		
		private function tryLeftElder(index:int,filterElderArr:Array):Boolean{
			Assert.AssertTrue(index>=0 && index<GameSize.s_cols*GameSize.s_rows);
			if(!FUtil.isSameRow(index,index-1))return false;
			if(index-1<0)return false;
			if(filterElderArr.indexOf(index-1)>=0)return false;
			
			var me:Node=m_nodeMap[index];
			var leftNode:Node=m_nodeMap[index-1];
			if(leftNode==null)return false;
			var leftElderNode:Node=leftNode.elderNode;
			if(leftElderNode==null)return false;
			if(leftElderNode.col>=leftNode.col){
				//叔叔与侄子在视觉上的差距不能大于1；
				var leftElderRightNephew:Node=leftElderNode.childrenNodes[Relation.RIGHT_NEPHEW];
				if(leftElderRightNephew!=null){
					CONFIG::DEBUG{
						s_log.info("::tryLeftElder()，节点"+index+"的视觉左节点的逻辑父节存在右侄子节点，视觉左节点/逻辑父节点/右侄子节点为：",leftNode.index,leftElderNode.index,leftElderRightNephew.index);
					};
					if(leftElderRightNephew.index==index){
						me.elderNode=leftElderNode;
						me.relationToElderNode=Relation.RIGHT_NEPHEW;
						return true;
					}else return false;
				}else{
					if(m_map[me.index]==null)leftElderNode.childrenNodes[Relation.RIGHT_NEPHEW]=me;
					me.elderNode=leftElderNode;
					me.relationToElderNode=Relation.RIGHT_NEPHEW;
					return true;
				}
			}else{
				CONFIG::DEBUG{
					s_log.info("::tryLeftElder()，节点"+index+"的视觉左节点的逻辑父节点过于偏离，视觉左节点/逻辑父节点为：",leftNode.index,leftElderNode.index);
				};
				return false;
			}
		}
		
		private function tryLeftUp(index:int,filterElderArr:Array):Boolean{
			Assert.AssertTrue(index>=0 && index<GameSize.s_cols*GameSize.s_rows);
			if(!FUtil.isSameRow(index,index-1))return false;
			if(index-1<0)return false;
			var leftUpIndex:int=index-1-GameSize.s_cols;
			if(leftUpIndex<0)return false;
			if(filterElderArr.indexOf(leftUpIndex)>=0)return false;
			
			var me:Node=m_nodeMap[index];
			var leftUpNode:Node=m_nodeMap[leftUpIndex];
			if(leftUpNode==null)return false;
			var leftUpRightNephewNode:Node=leftUpNode.childrenNodes[Relation.RIGHT_NEPHEW];
			if(leftUpRightNephewNode!=null){
				CONFIG::DEBUG{
					s_log.info("::tryLeftUp()，节点"+index+"的视觉左上节点存在右侄子节点，视觉左上节点/右侄子节点为：",leftUpNode.index,leftUpRightNephewNode.index);
				};
				if(leftUpRightNephewNode.index==index){
					me.elderNode=leftUpNode;
					me.relationToElderNode=Relation.RIGHT_NEPHEW;
					return true;
				}else return false;
			}else{
				if(m_map[me.index]==null)leftUpNode.childrenNodes[Relation.RIGHT_NEPHEW]=me;
				me.elderNode=leftUpNode;
				me.relationToElderNode=Relation.RIGHT_NEPHEW;
				return true;
			}
		}
		
		/**
		 * 检查索引是否为开始节点索引； 
		 * @param index
		 * @return 
		 * 
		 */
		/*public function isIndexStart(index:int):Boolean{
			return m_roots.indexOf(index)>=0;
		}*/
		
		/**
		 * 检查index所在的节点及其祖先节点是否连接在了开始节点上； 
		 * @param index
		 * @return 
		 * 
		 */
		/*public function checkAncestorConnToStart(index:int):Boolean{
			do{
				var node:FNode=m_nodeMap[index];
				if(node==null)return false;
				if(filterNodes.indexOf(index)>=0)return false;
				index=node.elderNode.index;
			}while(!isIndexStart(node.index));
			return true;
		}*/
		
		/**
		 * 断开指定index的节点与其父节点的连接；
		 * @param index
		 * @param priority
		 * 
		 */
		public function breakElderNode(index:int,priority:uint):void{
			var me:Node=m_nodeMap[index];
			if(me==null)return;
			var elderNode:Node=me.elderNode;
			
			switch(priority)
			{
				case FPriority.ELDER:
				{
					if(elderNode!=null)elderNode.childrenNodes[me.relationToElderNode]=null;
					break;
				}
				case FPriority.SELF:
				{
					me.elderNode=null;
					me.relationToElderNode=Relation.MAX_CHILDREN;
					break;
				}
				case FPriority.ALL:
				default:
				{
					if(elderNode!=null)elderNode.childrenNodes[me.relationToElderNode]=null;
					me.elderNode=null;
					me.relationToElderNode=Relation.MAX_CHILDREN;
					break;
				}
			}
		}
		
		public function breakChildrenNodes(index:int,whichChild:uint,priority:uint,childrenIndexs:Array=null):void{
			var me:Node=m_nodeMap[index];
			if(me==null)return;
			
			var checkChildArr:Array=[];
			switch(whichChild)
			{
				case Relation.LEFT_NEPHEW:
				{
					checkChildArr.push(Relation.LEFT_NEPHEW);
					break;
				}
				case Relation.SON:
				{
					checkChildArr.push(Relation.SON);
					break;
				}
				case Relation.RIGHT_NEPHEW:
				{
					checkChildArr.push(Relation.RIGHT_NEPHEW);
					break;
				}
				case Relation.MAX_CHILDREN:
				default:
				{
					checkChildArr.push(Relation.SON);
					checkChildArr.push(Relation.LEFT_NEPHEW);
					checkChildArr.push(Relation.RIGHT_NEPHEW);
					break;
				}
			}
			
			while(checkChildArr.length>0){
				var which:int=checkChildArr.shift();
				var childNode:Node=me.childrenNodes[which];
				if(childNode==null)continue;
				if(childrenIndexs)childrenIndexs.push(childNode.index);
				breakElderNode(childNode.index,priority);
			}
		}
		
		/**
		 * [20,20,[0,10,20,30,40,50,60],[],[],[],[],[],[]]
		 * @param arr
		 * 
		 */
		public function setData(roadArr:Array,startArr:Array):void{
			m_roots=startArr.concat();
			m_nodeMap=new Vector.<Node>(GameSize.s_cols*GameSize.s_rows);
			m_noElderNodes.length=0;
			for (var j:int=0;j<roadArr.length;j++){
				var subArr:Array=roadArr[j];
				var idx:int=subArr[0];
				var node:Node=new Node(idx,int(idx/GameSize.s_cols));
				m_nodeMap[idx]=node;
				if(startArr.indexOf(idx)<0)m_noElderNodes.push(idx);
				var childNode:Node;
				var i:int=1;
				while(i<subArr.length){
					idx=subArr[i];
					childNode=new Node(idx,int(idx/GameSize.s_cols));
					m_nodeMap[idx]=childNode;
					node.childrenNodes[Relation.SON]=childNode;
					childNode.elderNode=node;
					childNode.relationToElderNode=Relation.SON;
					node=childNode;
					i++;
				}
			}
			
			//没有与开始节点相连，尝试连接给其他节点；
			//连接给其他节点的依据是“视觉”相连；
			tryConnToElder();
			trace();
		}
		
		public function clean():void{
			m_noElderNodes.length=0;
			m_frozenNodes.length=0;
		}
	}
}