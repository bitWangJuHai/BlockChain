// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.16;

contract Navigation {

    struct adj
	{	
		bytes32 sourceGeohash;
		bytes32 targetGeohash;
		uint32 cost;
	}
	//遍历邻居列表能够找到所有邻居
	struct adj_types{
		uint32 adjnum;
		mapping (uint32 => adj) adjs;
	}
	//通过路口geohash找到其邻居列表
	mapping(bytes32 => adj_types) public adjacencyList;

	//参数P
	uint32 P = 1;

	struct pathType{
		uint32 num;
		mapping(uint32 => bytes32) index;
		mapping(bytes32 => bytes32) map;
	}
	struct costSofarType{
		uint32 num;
		mapping(uint32 => bytes32) index;
		mapping(bytes32 => uint32) map;
	}
	//记录每个节点的父节点
	pathType paths;
	//记录起点到当前节点的实际费用
	costSofarType costSofar;

    //每添加一个元素时更新peer状态
    function add_one_peer(uint32 cost, bytes32 sourceGeohash, bytes32 targetGeohash) external {
        adjacencyList[sourceGeohash].adjs[adjacencyList[sourceGeohash].adjnum].sourceGeohash = sourceGeohash;
		adjacencyList[sourceGeohash].adjs[adjacencyList[sourceGeohash].adjnum].targetGeohash = targetGeohash;
		adjacencyList[sourceGeohash].adjs[adjacencyList[sourceGeohash].adjnum++].cost = cost;
    }

	//astar算法主流程逻辑
    function astar(bytes32 startGeohash, bytes32 endGeohash) external returns(bytes32[] memory backwards, uint32 costAll){
		enqueue(startGeohash, 0);
		costSofar.map[startGeohash] = 0;
		costSofar.index[costSofar.num] = startGeohash;
		costSofar.num++;
		bytes32 currentGeohash;
		uint32 priority;
		while (frontier.geohashs.length > 1) {
			currentGeohash = top(); 
			//remove smallest item
			dequeue();
			adj_types storage adjNodes = adjacencyList[currentGeohash];
			if (currentGeohash == endGeohash) {
				costAll = costSofar.map[currentGeohash];
				//处理paths获得最短路径
				bytes32 current = endGeohash;
				backwards = new bytes32[](paths.num);
				uint32 i = 0;
				while(current != startGeohash){
					backwards[i] = current;
					current = paths.map[current];
					i++;
				}
				backwards[i] = startGeohash;
				//将结构体清空
				for(uint32 j = 0; j < paths.num; j++){
					delete paths.map[paths.index[j]];
					delete paths.index[j];
				}
				paths.num = 0;
				for(uint32 j = 0; j < costSofar.num; j++){
					delete costSofar.map[costSofar.index[j]];
					delete costSofar.index[j];
				}
				costSofar.num = 0;
				while (frontier.geohashs.length > 1){
					dequeue();
				}
				break;
			}

			for (uint32 i = 0; i < adjNodes.adjnum; i++) {
				uint32 newCost = costSofar.map[currentGeohash] + uint32(adjacencyList[currentGeohash].adjs[i].cost);
				if (costSofar.map[adjNodes.adjs[i].targetGeohash] == 0 || newCost < costSofar.map[adjNodes.adjs[i].targetGeohash]) {
					if(costSofar.map[adjNodes.adjs[i].targetGeohash] == 0){
						costSofar.index[costSofar.num] = adjNodes.adjs[i].targetGeohash;
						costSofar.num++;
					}
					costSofar.map[adjNodes.adjs[i].targetGeohash] = newCost;
					priority = newCost * P + manhattan(adjNodes.adjs[i].targetGeohash, endGeohash);
					enqueue(adjNodes.adjs[i].targetGeohash, priority);
					if(paths.map[adjNodes.adjs[i].targetGeohash] == 0x0000000000000000000000000000000000000000000000000000000000000000){
						paths.index[paths.num] = adjNodes.adjs[i].targetGeohash;
						paths.num++;
					}
					paths.map[adjNodes.adjs[i].targetGeohash] = currentGeohash;
				}
			}
		}
	}
	
	function manhattan(bytes32 nextGeohash, bytes32 endGeohash) internal view returns (uint32){
		if(nextGeohash == endGeohash){
			return 0;
		}
		//数该长度下的geohash对应的格子数
		
		//前缀匹配优化速度
		string memory shortNext;
		string memory shortEnd;
		
		(shortNext, shortEnd) = sliceGeoHash(nextGeohash, endGeohash);

		uint32 dislat1 = getLatBlock(shortNext);
		uint32 dislat2 = getLatBlock(shortEnd);
		uint32 dislon1 = getLonBlock(shortNext);
		uint32 dislon2 = getLonBlock(shortEnd);

		uint32 dislat;
		uint32 dislon;
		if(dislat2 > dislat1){
			dislat = dislat2 - dislat1;
		}else{
			dislat = dislat1 - dislat2;
		}
		if(dislon2 > dislon1){
			dislon = dislon2 - dislon1;
		}else{
			dislon = dislon1 - dislon2;
		}
		return (dislat + dislon);
	}
	
	//前缀匹配，geohash精度调整为8
	uint32 PRECISION = 8;
	function changePrecision(uint32 newPrecision) external returns (uint32){
		PRECISION = newPrecision;
		return PRECISION;
	}
	function changeP(uint32 newP) external returns (uint32){
		P = newP;
		return P;
	}
	function sliceGeoHash(bytes32 geohash1, bytes32 geohash2) internal view returns (string memory, string memory){
		bytes32 geo1 = geohash1;
		bytes32 geo2 = geohash2;
		uint32 len = geo1.length;
		//geohash different start index
		uint32 index;
		//geohash different length
		uint32 dif = 0;
		for (index = 0; index < len; index++) {
			if (geo1[index] != geo2[index]) {
				break;
			}
		}
		dif = PRECISION - index;
		uint32 index2 = 0;
		bytes memory shortGeo1 = new bytes(dif);
		bytes memory shortGeo2 = new bytes(dif);
		for (uint32 j = index; j < PRECISION; j++) {
			shortGeo1[index2] = geo1[j];
			shortGeo2[index2] = geo2[j];
			index2++;
		}
		return (string(shortGeo1), string(shortGeo2));
	}
	
	uint32[] Bits = [16, 8, 4, 2, 1];
	string Base32 = "0123456789bcdefghjkmnpqrstuvwxyz";
	//geohash在纬度上的块数
	function getLatBlock(string memory geohash) internal view returns (uint32) {
		//geohash纬度
		bool even = true;
		uint32 lat = 0;
		for (uint32 i = 0; i < bytes(geohash).length; i++) {
			bytes1 c = bytes(geohash)[i];
			uint32 cd;
			for (uint32 j = 0; j < bytes(Base32).length; j++) {
				if (bytes(Base32)[j] == c) {
					cd = j;
					break;
				}
			}
			for (uint32 j = 0; j < 5; j++) {
				uint32 mask = Bits[j];
				if (even) {
					lat = lat * 2;
					if ((cd & mask) != 0) {
						lat = lat + 1;
					}
				}
				even = !even;
			}
		}
		return lat;
	}
	//geohash在经度上的块数
	function getLonBlock(string memory geohash) internal view returns (uint32) {
		//geohash经度
		bool even = true;
		uint32 lon = 0;
		for (uint32 i = 0; i < bytes(geohash).length; i++) {
			bytes1 c = bytes(geohash)[i];
			uint32 cd;
			for (uint32 j = 0; j < bytes(Base32).length; j++) {
				if (bytes(Base32)[j] == c) {
					cd = j;
					break;
				}
			}
			for (uint32 j = 0; j < 5; j++) {
				uint32 mask = Bits[j];
				if (!even) {
					lon = lon * 2;
					if ((cd & mask) != 0) {
						lon = lon + 1;
					}
				}
				even = !even;
			}
		}
		return lon;
	}
	
	//实现优先队列
	struct Heap {
		bytes32[] geohashs;
		mapping(bytes32 => uint32) map;
	}
	//唯一实例
	Heap frontier;
	//判断是否为空
	modifier notEmpty() {
		require(frontier.geohashs.length > 1);
		_;
	}
	//获得头元素
	function top() internal view notEmpty() returns(bytes32) {
		return frontier.geohashs[1];
	}
	//出队（直接删除无返回值）
	function dequeue() internal notEmpty(){
		require(frontier.geohashs.length > 1);
		
		bytes32 toReturn = top();
		frontier.geohashs[1] = frontier.geohashs[frontier.geohashs.length - 1];
		frontier.geohashs.pop();

		uint32 i = 1;

		while (i * 2 < frontier.geohashs.length) {
			uint32 j = i * 2;

			if (j + 1 < frontier.geohashs.length)
				if (frontier.map[frontier.geohashs[j]] > frontier.map[frontier.geohashs[j + 1]]) 
					j++;
			
			if (frontier.map[frontier.geohashs[i]] < frontier.map[frontier.geohashs[j]])
				break;
			
			(frontier.geohashs[i], frontier.geohashs[j]) = (frontier.geohashs[j], frontier.geohashs[i]);
			i = j;
		}
		delete frontier.map[toReturn];
	}
	//入队
	function enqueue(bytes32 geohash, uint32 cost) internal {
		if (frontier.geohashs.length == 0) 
			// initialize
			frontier.geohashs.push(0x0000000000000000000000000000000000000000000000000000000000000000); 
		
		frontier.geohashs.push(geohash);
		frontier.map[geohash] = cost;
		uint256 i = frontier.geohashs.length - 1;
		while (i > 1 && frontier.map[frontier.geohashs[i / 2]] > frontier.map[frontier.geohashs[i]]) {
			(frontier.geohashs[i / 2], frontier.geohashs[i]) = (geohash, frontier.geohashs[i / 2]);
			i /= 2;
		}
	}

}