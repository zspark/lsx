package z_spark.fallingsystem
{
	import z_spark.kxxxlcore.GameSize;

	public final class Node
	{
		public var relationToElderNode:uint=Relation.MAX_CHILDREN;
		public var elderNode:Node;
		public var childrenNodes:Vector.<Node>;
		private var m_index:int;
		private var m_deep:int;
		public function Node(idx:int,depth:int)
		{
			childrenNodes=new Vector.<Node>(Relation.MAX_CHILDREN);
			m_index=idx;
			m_deep=depth;
		}

		public function get deep():int	{return m_deep;}
//		public function set deep(value:int):void{m_deep = value;}
		public function get index():int{return m_index;}
		public function get row():int{return int(m_index/GameSize.s_cols);}
		public function get col():int{return m_index%GameSize.s_cols;}
		
		/**
		 *断开自己对外界的连接； 
		 * 
		 */
		public function breakGoingOuts():void{
			elderNode=null;
			relationToElderNode=Relation.MAX_CHILDREN;
			var i:int=Relation.MAX_CHILDREN;
			while(--i>=0){
				childrenNodes[i]=null;
			}
		}
		
		/**
		 *断开外界对自己的连接； 
		 * 参数返回子节点索引;
		 */
		public function breakComingIns(childrenIndexs:Array=null):void{
			if(childrenIndexs)childrenIndexs.length=0;
			if(elderNode){
				elderNode.childrenNodes[relationToElderNode]=null;
			}
			var i:int=Relation.MAX_CHILDREN;
			while(--i>=0){
				var childNode:Node=childrenNodes[i];
				if(childNode){
					if(this==childNode.elderNode){
						childNode.elderNode=null;
						childNode.relationToElderNode=Relation.MAX_CHILDREN;
					}/*else{
						throw "严重逻辑错误！孩子节点的父节点不一致！me="+index+" child="+childNode.index+" child's elder="+childNode.elderNode.index+" childRelation="+childNode.relationToElderNode;
					}*/
					if(childrenIndexs)childrenIndexs.push(childNode.index);
				}
			}
		}
		
		public function hasChild():Boolean{
			return childrenNodes[0] ||childrenNodes[1] ||childrenNodes[2];
		}
		
		public function getExistChildrenNodes(arr:Array):void{
			arr.length=0;
			if(childrenNodes[0])arr.push(childrenNodes[0]);
			if(childrenNodes[1])arr.push(childrenNodes[1]);
			if(childrenNodes[2])arr.push(childrenNodes[2]);
		}
		
		public function getNextChildNodeWithPriority():Node{
			return childrenNodes[Relation.SON] || childrenNodes[Relation.LEFT_NEPHEW] || childrenNodes[Relation.RIGHT_NEPHEW];
		}
		
	}
}