// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.16;

import { Navigation } from "./Navigation.sol";

contract StoreMap {

	struct one_element{	
		uint32 minzoom;
		uint32 cost;
		bool  oneway;
		bool  building;
		bytes32 highway;
		bytes32 name;
		uint32 source;
		uint32 target;
		bytes32 gtype;
		uint32 path_num;
		mapping(uint32 => bytes32) path;
	}
	mapping(uint32 => one_element) all_elements;

	struct area{
		uint32 num;
		mapping(uint32 => uint32) element_index;
	}
	mapping(bytes32 => area) public geo_maps;

	Navigation nav;

	constructor() {
		nav = new Navigation();
	}

	//获取对应geohash区域内所有地图元素
	function get_elements(bytes32 hash) view public returns (uint32[] memory feature, bytes32[] memory names, bytes32[] memory highways, bytes32[] memory gtypes, bytes32[] memory path) {
		uint32 num = geo_maps[hash].num;
		uint32 path_num = 0;
		uint32 i = 0;
		uint32 j = 0;

		if(num > 0){
			feature = new uint32[](7 * num);
			names = new bytes32[]( num );
			highways = new bytes32[]( num );
			gtypes = new bytes32[]( num );
			uint32 gid;
			for(i = 0; i < num; i++){
				//从元素集合内获得该元素
				gid = geo_maps[hash].element_index[i]; 
				one_element storage ele1 = all_elements[gid];
				//将一些元素放到返回值内
				uint32 base = i * 7;
				feature[base] = gid;
				feature[base + 1] = ele1.minzoom;
				feature[base + 2] = ele1.cost;
				feature[base + 3] = ele1.source;
				feature[base + 4] = ele1.target;
				if(ele1.oneway){
					feature[base + 5] = 1;
				}
				else{
					feature[base + 5] = 0;
				}
				if(ele1.building){
					feature[base + 6] = 1;
				}
				else{
					feature[base + 6] = 0;
				}
				names[i] = ele1.name;
				highways[i] = ele1.highway;
				gtypes[i] = ele1.gtype;
				//区域总路径点数增加
				path_num = path_num + 1 + ele1.path_num;
			}

			//根据总路径点数量形成全体路径点的数组
			path = new bytes32[](path_num);
			uint32 pos = 0;
			for(i = 0; i < num; i++){
				gid = geo_maps[hash].element_index[i];
				one_element storage ele2 = all_elements[gid];
				for(j = 0; j < ele2.path_num; j++){
					path[pos++] = ele2.path[j];
				}
			}
		}
	}

	function add_one_element(uint32 gid, uint32 minzoom, uint32 cost, uint32 source, uint32 target, bool oneway, bool building, bytes32 highway, bytes32 name, bytes32 gtype, bytes32[] memory path) public {
		all_elements[gid].minzoom = minzoom;
		all_elements[gid].cost = cost;
		all_elements[gid].source = source;
		all_elements[gid].target = target;
		all_elements[gid].oneway = oneway;
		all_elements[gid].building = building;
		all_elements[gid].highway = highway;
		all_elements[gid].name = name;
		all_elements[gid].gtype = gtype;
		
		nav.add_one_peer(cost, path[0], path[path.length - 1]);

		uint32 num = all_elements[gid].path_num;
		for(uint32 i=0; i< path.length; i++){
			all_elements[gid].path[num++] = path[i];
		}
		all_elements[gid].path_num = num;
	}

	function add_area_element(bytes32 hash, uint32 gid) public {
		uint32 num = geo_maps[hash].num++;
		geo_maps[hash].element_index[num] = gid;
	}

	function astar(bytes32 startGeohash, bytes32 endGeohash) public returns(bytes32[] memory backwards, uint32 costAll){
		return nav.astar(startGeohash, endGeohash);
	}
	function changePrecision(uint32 newPrecision) public returns (uint32){
		return nav.changePrecision(newPrecision);
	}
	function changeP(uint32 newP) public returns (uint32){
		return nav.changeP(newP);
	}
	function get_types(bytes32 hash) view public returns (uint32[] memory feature, bytes32[] memory names, bytes32[] memory highways, bytes32[] memory gtypes, bytes32[] memory path) {
		return get_elements(hash);
	}

}

