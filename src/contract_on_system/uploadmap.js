//获取地图中的所有元素
var fs = require('fs');			//这个fs是从读者个人的包地址导入的，fs是node自带的包不需要特殊下载
var map_file = "./costMap_GeoHash.json";	//上传的测试用地图文件
var maps = fs.readFileSync(map_file);
var obj = JSON.parse(maps);
var elements = obj.features;				//得到地图的每个元素

//编译合约
var solc = require('solc')		//此处使用的是读者个人的solc包，是使用npm下载的
var contractCode = fs.readFileSync("./StoreMap.sol", "utf-8")
var contractImportCode = fs.readFileSync("./Navigation.sol", "utf-8")
var input = {
    "language": "Solidity",
    "sources": {
      "StoreMap.sol": {
        "content": contractCode
      }
    },
    "settings": {
      "outputSelection": {
        "*": {
          "*": ["*"]
        }
      }
    }
  };
function findImports(path) {
    if (path === 'Navigation.sol'){
        return { contents: contractImportCode };
    } else {
        return { error: 'File not found' };
    }
}
var output = JSON.parse(
    solc.compile(JSON.stringify(input), { import: findImports })
)
var storeMap_abi = output.contracts['StoreMap.sol']['StoreMap'].abi
var storeMap_bytecode = output.contracts['StoreMap.sol']['StoreMap'].evm.bytecode.object

//部署合约
var web3 = require('web3')		//此处使用的是读者个人的web3包，是使用npm下载的
async function deploy(account){
    var storeMapContract = new web3.eth.Contract(storeMap_abi)
    var storeMapInstance = await storeMapContract.deploy({
        data: storeMap_bytecode,
        arguments: []
      }).send({
        from: account,
        gas: 1500000,
        gasPrice: '19904412217'
      }, (err, transactionHash) => {
        if( !err ){
          console.log("TransactionHash: " + transactionHash)
          console.log("Waiting for mine")
        } else {
          console.log("Deploy error: " + err)
        }
      }).on('receipt', (receipt) => {
        console.log("Mined! (contractAddress: " + receipt.contractAddress + ")")
      })

    return storeMapInstance
}
var accounts = await web3.eth.getAccounts()
var storeMapInstance = await deploy(accounts[0])

//上传地图
uploadMap();

//counter计数器用于记录当前已经上传成功的元素数
let counter = 0;
function uploadMap() {
	let partTask = [];
    //loopNum用于设定每个区块上链的交易数量（每个交易是一次元素上链函数的调用，由于交易提交速度远快于出块速度，所以基本上是每块200个交易）
	let loopNum = 200;

    //上传loopNum个元素
	for (let i = 0; i < loopNum; i++) {
		partTask.push(add_one_element(elements[counter]));
		counter++;
        //如果上传完成counter == elements.length
		if ((elements.length - counter) == 0) {
            //等待所有partTask中的promise结束回调（所有交易上链）
			Promise.all(partTask).then((resolve) => {
				console.log("地图数据上传完成");
			}, (reject) => { })
            //源程序此处是break，笔者认为如果元素数正好是loopNum的整数倍break之后执行if语句会出问题，故修改为return
			return;
		}
	}
    //上传loopNum个元素之后继续上传
	if (partTask.length == loopNum) {
		Promise.all(partTask).then((resolve) => {
			uploadMap();
		}, (reject) => { })
	}
}

var hash_array;
async function add_one_element(element) {
	var minzoom;
	var cost;
	var source;
	var target;
	var oneway;
	var building;
	var name;
	var highway;
	var gid;

	var element_json = element;
	var path_arr = element_json.geometry.coordinates;

	var gas = 3000000;
	var path_length = 0;
	var path = [];
	// 判断是否是多边形
	// console.log(element_json.geometry.type);
	if (element_json.geometry.type == "Point") {
		minzoom = 14;
		var point_x = parseFloat(path_arr[0]);
		var point_y = parseFloat(path_arr[1]);
		var point_geohash = encode_geohash(point_x, point_y, 11);
		path.push(point_geohash);
		gas += 110000;
		// console.log("onepoint",point_geohash);
	}
	else if (element_json.geometry.type == "LineString") {
		minzoom = 7;
		path_length = path_arr.length;
		// console.log(path_length);
		for (var i = 0; i < path_length; i++) {
			path.push(path_arr[i]);
			gas += 110000;
			// console.log("onepoint",point_geohash);
		}
	}
	else if (element_json.geometry.type == "MultiPolygon") {
		minzoom = 12;
		path_length = path_arr[0][0].length;
		// console.log(path_length);
		for (var i = 0; i < path_length; i++) {
			var point = path_arr[0][0][i];
			var point_x = parseFloat(point[0]);
			var point_y = parseFloat(point[1]);
			var point_geohash = encode_geohash(point_x, point_y, 11);
			path.push(point_geohash);
			gas += 110000;
			// console.log("onepoint",point_geohash);
		}
	}
	// 获取其他必要参数值 
	cost = element_json.properties.cost;
	source = element_json.properties.source;
	target = element_json.properties.target;

	if (element_json.properties.name == undefined) {
		name = "";
	}
	else {
		name = element_json.properties.name;
	}
	if (element_json.properties.building == undefined) {
		building = 0;
	}
	else {
		building = 1;
	}
	if (element_json.properties.highway == undefined) {
		highway = "";
	}
	else {
		highway = element_json.properties.highway;
	}
	if (element_json.properties.oneway == undefined) {
		oneway = 0;
	}
	else {
		oneway = 1;
	}

	gid = element_json.properties.gid;
	// 将地图信息存储到区块链
	await add_one_element(gid, minzoom, cost, source, target, oneway, building, highway, name, element_json.geometry.type, path, gas, 0);
	// console.log(counter,minzoom,oneway,building,highway,name,element_json.geometry.type,path);

	// console.log(path);
	//区域绑定
	hash_array = new Array();
	if (element_json.geometry.type == "Point" || element_json.geometry.type == "MultiPolygon") {
		await bind_other_geohash(gid, path);
	}
	else if (element_json.geometry.type == "LineString") {
		await bind_road_geohash(gid, path);
	}
}

// 将一条道路绑定在geohash区域上
async function bind_road_geohash(gid, path) {
	//get areas which has intersection with the road. for lon, 0.01 degree is equal to about 1000m and 1113m for lat
	for (var i = 0; i < path.length; i++) {
		area_geohash5 = path[i].slice(0, 5)
		if ((hash_array.indexOf(area_geohash5) != -1)) {
			continue;
		}
		if (hash_array.indexOf(area_geohash5) == -1) {
			hash_array.push(area_geohash5);
			await add_area_element(area_geohash5, gid, 5000000);
			console.log("area_geohash5", area_geohash5);
		}
	}
}

// 将其它类型绑定在geohash区域上
async function bind_other_geohash(gid, path) {
	// 对于Point和MultiPolygon，直接根据前缀绑定
	for (var i = 0; i < path.length; i++) {
		var area_geohash4 = path[i].slice(0, 4);
		if ((hash_array.indexOf(area_geohash4) != -1)) {
			continue;
		}
		if (hash_array.indexOf(area_geohash4) == -1) {
			hash_array.push(area_geohash4);
			await add_area_element(area_geohash4, gid, 5000000);
			console.log("area_geohash4", area_geohash4);
		}
	}
}

//向指定geohash区域内添加一个元素
async function add_area_element(geohash, gid, gas) {
    var retry_time = 0
    while(retry_time < 10){
        await storeMapInstance.method.add_area_element(geohash, gid).send({
            from: accounts[0], 
            gas: gas, 
            position: "w3511111111111", 
            txtime: 278000 
         })
         .on('transactionhash', (hash) => {
            console.log("transaction submit! geohash: " + geohash + ", gid: " + gid)
         })
         .on('receipt', (receipt) => {
            console.log("mined! geohash: " + geohash + ", gid: " + gid + " At " + receipt.blockNumber)
         })
         .on('error', (err) => {
            console.log("bind road failed. geohash: " + geohash + " ,gid: " + gid);
            console.log('err: ' + err)
            console.log("retry!")
            retry_time++
         })
    }
    //重试10此均未成功
	console.log("bind road failed. geohash: " + geohash + " ,gid: " + gid);
	return;
}

async function add_one_element(gid, minzoom, cost, source, target, oneway, building, highway, name, gtype, path, gas, retry_times) {
	if (retry_times > 10) {
		console.log("add element failed. gid: " + gid);
		return;
	}
	// console.log("source, target", source, target);
	await storeMapInstance.add_one_element(gid, minzoom, cost, source, target, oneway, building, highway, name, gtype, path, { from: accounts[0], gas: gas, position: "w3511111111111", txtime: 278000 }).then(function (result) {
		console.log("gid: ", gid);
		console.log("path: ", path)
	},
		function (err) {
			//retry
			console.log("add_one_element err: ", err)
			add_one_element(gid, minzoom, cost, source, target, oneway, building, highway, name, gtype, path, gas, retry_times + 1);
		});
}

// var precision = 6;
var Bits = [16, 8, 4, 2, 1];
var Base32 = "0123456789bcdefghjkmnpqrstuvwxyz".split("");

function encode_geohash(longitude, latitude, precision) {
	var geohash = "";
	var even = true;
	var bit = 0;
	var ch = 0;
	var pos = 0;
	var lat = [-90, 90];
	var lon = [-180, 180];
	while (geohash.length < precision) {
		var mid;

		if (even) {
			mid = (lon[0] + lon[1]) / 2;
			if (longitude > mid) {
				ch |= Bits[bit];
				lon[0] = mid;
			}
			else
				lon[1] = mid;
		}
		else {
			mid = (lat[0] + lat[1]) / 2;
			if (latitude > mid) {
				ch |= Bits[bit];
				lat[0] = mid;
			}
			else
				lat[1] = mid;
		}
		even = !even;
		if (bit < 4)
			bit++;
		else {
			geohash += Base32[ch];
			bit = 0;
			ch = 0;
		}
	}
	return geohash;
}
