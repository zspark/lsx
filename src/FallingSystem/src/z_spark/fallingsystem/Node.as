package z_spark.fallingsystem
{
	import z_spark.kxxxlcore.GameSize;

	public final class Node
	{
		public var isOccupied:Boolean=false;
		
		private var m_relationToElderNode:uint=Relation.MAX_CHILDREN;
		private var m_elderNode:Node;
		public var childrenNodes:Vector.<Node>;
		private var m_index:int;
		private var m_deep:int;
		
		public var supplyNodes:Vector.<Node>;
		public function Node(idx:int,depth:int)
		{
			supplyNodes=new Vector.<Node>(Relation.MAX_CHILDREN);
			childrenNodes=new Vector.<Node>(Relation.MAX_CHILDREN);
			m_index=idx;
			m_deep=depth;
		}

		public function get relationToElderNode():uint{return m_relationToElderNode;}
		public function get elderNode():Node{return m_elderNode;}

		public function setElderNode(node:Node,relation:uint):void
		{
			if(relation>=Relation.MAX_CHILDREN){
				throw "参数不合法！";
			}
			if(m_elderNode){
				m_elderNode.childrenNodes[m_relationToElderNode]=null;
			}
			
			m_elderNode = node;
			if(node==null){
				m_relationToElderNode=Relation.MAX_CHILDREN;
			}else {
				m_relationToElderNode=relation;
				m_elderNode.childrenNodes[relation]=this;
			}
		}
		
		public function get deep():int	{return m_deep;}
		public function get index():int{return m_index;}
		public function get row():int{return int(m_index/GameSize.s_cols);}
		public function get col():int{return m_index%GameSize.s_cols;}
		
		
		public function hasChild():Boolean{
			return childrenNodes[0] ||childrenNodes[1] ||childrenNodes[2];
		}
		
		public function getExistChildrenNodes(arr:Array):void{
			arr.length=0;
			if(childrenNodes[0])arr.push(childrenNodes[0]);
			if(childrenNodes[1])arr.push(childrenNodes[1]);
			if(childrenNodes[2])arr.push(childrenNodes[2]);
		}
		
		public function getExistSupplyNodes(arr:Array):void{
			arr.length=0;
			if(supplyNodes[0])arr.push(supplyNodes[0]);
			if(supplyNodes[1])arr.push(supplyNodes[1]);
			if(supplyNodes[2])arr.push(supplyNodes[2]);
		}
		
		public function getNextSupplyNodeWithPriority():Node{
			return supplyNodes[Relation.SON] || supplyNodes[Relation.LEFT_NEPHEW] || supplyNodes[Relation.RIGHT_NEPHEW];
		}
		
	}
}