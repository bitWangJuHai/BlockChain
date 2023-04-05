//获取地图中的所有元素
var fs = require('fs');			//这个fs是从读者个人的包地址导入的，fs是node自带的包不需要特殊下载
var map_file = "./costMap_GeoHash.json";	//上传的测试用地图文件
var maps = fs.readFileSync(map_file);
var obj = JSON.parse(maps);
var elements = obj.features;				//得到地图的每个元素

//编译合约，该部分在之前的复现中已经介绍过在此不做赘述
var solc = require('solc')		//此处使用的是读者个人的solc包，是使用npm下载的
var storeMapCode = fs.readFileSync("./StoreMap.sol", "utf-8")
var storeMapImportCode = fs.readFileSync("./Navigation.sol", "utf-8")
var storeTrafficCode = fs.readFileSync("./StoreTraffic.sol", "utf-8")
var creditCode = fs.readFileSync("./credit.sol", "utf-8")
var input = {
    "language": "Solidity",
    "sources": {
      "StoreMap.sol": {
        "content": storeMapCode
      },
	  "StoreTraffic.sol": {
        "content": storeTrafficCode
      },
	  "credit.sol": {
		"content": creditCode
	  },
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
        return { contents: storeMapImportCode };
    } else {
        return { error: 'File not found' };
    }
}
var output = JSON.parse(
    solc.compile(JSON.stringify(input), { import: findImports })
)
var storeMap_abi = output.contracts['StoreMap.sol']['StoreMap'].abi
var storeMap_bytecode = output.contracts['StoreMap.sol']['StoreMap'].evm.bytecode.object
var storeTraffic_abi = output.contracts['StoreTraffic.sol']['StoreTraffic'].abi
var storeTraffic_bytecode = output.contracts['StoreTraffic.sol']['StoreTraffic'].evm.bytecode.object
var credit_abi = output.contracts['credit.sol']['Credit'].abi
var credit_bytecode = output.contracts['credit.sol']['Credit'].evm.bytecode.object

//合约部署函数
var Web3 = require('web3')		//此处使用的是读者个人的web3包，是使用npm下载的
var web3 = new Web3('http://127.0.0.1:8546')	//端口修改成本地运行geth1的rpc服务器端口
async function deploy(){
	accounts = await web3.eth.getAccounts()
	var storeMapContract = new web3.eth.Contract(storeMap_abi)
	var storeTrafficContract = new web3.eth.Contract(storeTraffic_abi)
	var creditContract = new web3.eth.Contract(credit_abi)
	//部署地图存储合约
	await storeMapContract.deploy({
		data: storeMap_bytecode,
		arguments: []
	}).send({
		from: accounts[0],
		gas: 6000000,
		gasPrice: '19904412217'
	}, (err, transactionHash) => {
		if( !err ){
		console.log("TransactionHash: " + transactionHash)
		console.log("Waiting for mine")
		} else {
		console.log("Deploy error: " + err)
		}
	})
	.on('receipt', (receipt) => {
		console.log("Mined! (contractAddress: " + receipt.contractAddress + ")")
	})
	.then( (result) => {
		storeMapInstance = result
	})
	//部署交通存储合约
	await storeTrafficContract.deploy({
		data: storeTraffic_bytecode,
		arguments: []
	}).send({
		from: accounts[0],
		gas: 6000000,
		gasPrice: '19904412217'
	}, (err, transactionHash) => {
		if( !err ){
		console.log("TransactionHash: " + transactionHash)
		console.log("Waiting for mine")
		} else {
		console.log("Deploy error: " + err)
		}
	})
	.on('receipt', (receipt) => {
		console.log("Mined! (contractAddress: " + receipt.contractAddress + ")")
	})
	.then( (result) => {
		storeTrafficInstance = result
	})
	//部署信誉值评估合约
	await creditContract.deploy({
		data: credit_bytecode,
		arguments: []
	}).send({
		from: accounts[0],
		gas: 6000000,
		gasPrice: '19904412217'
	}, (err, transactionHash) => {
		if( !err ){
		console.log("TransactionHash: " + transactionHash)
		console.log("Waiting for mine")
		} else {
		console.log("Deploy error: " + err)
		}
	})
	.on('receipt', (receipt) => {
		console.log("Mined! (contractAddress: " + receipt.contractAddress + ")")
	})
	.then( (result) => {
		creditInstance = result
	})
}

var accounts
var storeMapInstance
var storeTrafficInstance
var creditInstance

//先等待部署完成再上传地图
deploy().then( () => {
	uploadMap()
})

//counter计数器用于记录当前已经上传成功的元素数
var counter = 0
function uploadMap() {
	var partTask = [];
    //loopNum用于设定每个区块上最多多少交易（块上的交易数量还受每块的汽油费上限限制，测试地图一共1280个元素总共需要不到150块）
	var loopNum = 200;

    //上传loopNum个元素
	for (var i = 0; i < loopNum; i++) {
		partTask.push(add_one_element(elements[counter]));		//一个元素一个元素地上传
		counter++;
		//如果上传完成counter == elements.length
		if ((elements.length - counter) == 0) {
            //等待所有partTask中的promise结束回调（所有交易上链）
			Promise.all(partTask).then((resolve) => {
				console.log("地图数据上传完成!")
				console.log("地图存储合约所在地址: " + storeMapInstance._address)
				console.log("交通存储合约所在地址: " + storeTrafficInstance._address)
				console.log("信誉值评估合约所在地址: " + creditInstance._address)
			}, (reject) => { })
            //源程序此处是break，笔者认为如果元素数正好是loopNum的整数倍break之后执行if语句会出问题，故修改为return
			return;
		}
	}
    //上传loopNum个元素之后（一个块上链）继续上传
	//console.log(partTask.length)
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

	if (element_json.geometry.type == "Point") {		//如果是一个点元素
		minzoom = 14;									//点元素14缩放才能显示
		//将点的经纬度坐标转换成geohash
		var point_x = parseFloat(path_arr[0]);
		var point_y = parseFloat(path_arr[1]);
		var point_geohash = encode_geohash(point_x, point_y, 11);
		path.push(point_geohash);						//一个点的path只有一个值，不需要用循环直接push一个就可以
		//上链的时候要把path拷贝进区块，path越长消耗的汽油费越多。为每个元素的拷贝提供11000汽油费
		gas += 110000;									//点元素只加一次
	}
	else if (element_json.geometry.type == "LineString") {	//如果是一个线元素
		minzoom = 7;										//线元素7缩放就显示
		//把线元素的路径点添加到path中，LineString的cordinates就是一个基本类型一维数组，直接复制
		path = path_arr.slice()
		//增加汽油费
		gas += 110000 * path_arr.length;
	}
	else if (element_json.geometry.type == "MultiPolygon") {	//如果是重多边形
		minzoom = 12;											//冲多边形12缩放显示
		//此处笔者不太理解，认为源程序有问题，不做修改仅保留（暂时地图数据还没有这个类型）
		path_length = path_arr[0][0].length;
		for (var i = 0; i < path_length; i++) {
			var point = path_arr[0][0][i];
			var point_x = parseFloat(point[0]);
			var point_y = parseFloat(point[1]);
			var point_geohash = encode_geohash(point_x, point_y, 11);
			path.push(point_geohash);
			gas += 110000;
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

	//将path中的每个路径点的geohash表示转换成十六进制供合约存储
	var path_0x = []
	for(var i = 0; i < path.length; i++) {
		path_0x[i] = string_to_0x(path[i])
	}

	// 将地图信息存储到区块链
	await add_element_to_blockchain(gid, minzoom, cost, source, target, oneway, building, string_to_0x(highway), string_to_0x(name), string_to_0x(element_json.geometry.type), path_0x, gas);

	//将地图元素分类绑定到某个geohash区域
	hash_array = new Array();
	if (element_json.geometry.type == "Point" || element_json.geometry.type == "MultiPolygon") {
		await bind_other_geohash(gid, path);
	}
	else if (element_json.geometry.type == "LineString") {
		await bind_road_geohash(gid, path);
	}
}

//将一条道路绑定在若干个五位的geohash区域上，一块五位的geohash区域大概横向3.5km纵向4.75km
async function bind_road_geohash(gid, path) {
	for (var i = 0; i < path.length; i++) {
		area_geohash5 = path[i].slice(0, 5)					//看一下这个路径点在哪个五位的geohash区域内
		if (hash_array.indexOf(area_geohash5) == -1) {		//如果这条路跨过了某个五位的geohash区域，那么在新的区域内也应该有这条路存在
			hash_array.push(area_geohash5);					//记录一下这条路已经在哪个区域内绑定了
			//调用绑定元素函数
			await bind_element(string_to_0x(area_geohash5), gid, 5000000);
		}
	}
}

//将某个道路之外的类型绑定在四位的geohash区域上，四位的区域就很大了一个四位区域有32个五位区域
async function bind_other_geohash(gid, path) {
	for (var i = 0; i < path.length; i++) {
		var area_geohash4 = path[i].slice(0, 4)				//看一下这个路径点在哪个四位的geohash区域内
		if (hash_array.indexOf(area_geohash4) == -1) {		//如果这个元素跨过了某个四位的geohash区域，那么在新的区域内也应该有这个元素存在
			hash_array.push(area_geohash4);					//记录一下这个元素已经在哪个区域内绑定了
			//调用绑定元素函数
			await bind_element(string_to_0x(area_geohash4), gid, 5000000);
		}
	}
}

//向指定geohash区域内添加一个元素
async function bind_element(geohash, gid, gas) {
	await storeMapInstance.methods.add_area_element(geohash, gid).send({
		from: accounts[0], 
		gas: gas, 
		position: "w3511111111111", 
		txtime: 278000 
		})
		.on('transactionhash', (hash) => {			//交易提交成功时执行
			console.log("bind transaction submit! geohash: " + geohash + ", gid: " + gid)
			console.log("transactionHash: " + hash)
			console.log("Waiting for mine……")
		})
		.on('receipt', (receipt) => {				//收据可用（已经上链）时执行
			console.log("bind mined! geohash: " + geohash + ", gid: " + gid + " at block: " + receipt.blockNumber)
		})
		.on('error', (err) => {
			console.log("bind failed. geohash: " + geohash + " ,gid: " + gid);
			console.log('err: ' + err)
		})
}

async function add_element_to_blockchain(gid, minzoom, cost, source, target, oneway, building, highway, name, gtype, path, gas) {
	await storeMapInstance.methods.add_one_element(gid, minzoom, cost, source, target, oneway, building, highway, name, gtype, path).send({
		from: accounts[0],
		gas: gas,
		position: "w3511111111111",
		txtime: 278000
		})
		.on('transactionhash', (hash) => {
			console.log("add transaction submit! name: " + name + ", gid: " + gid)
			console.log("transactionHash: " + hash)
			console.log("Waiting for mine……")
		})
		.on('receipt', (receipt) => {
			console.log("add mined! name: " + name + ", gid: " + gid + " at block: " + receipt.blockNumber)
			console.log("path: " + path)
		})
		.on('error', (err) => {
			console.log("add failed. name: " + name + " ,gid: " + gid);
			console.log('err: ' + err)
		})
}

// var precision = 6;
var Bits = [16, 8, 4, 2, 1];
var Base32 = "0123456789bcdefghjkmnpqrstuvwxyz".split("");

//通过经纬度得到其geohash区域。精度本程序使用的是11
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

//将字符串转变成16进制的bytes供合约存储
function string_to_0x(str) {
	var str_0x = "0x";
	if(str == ""){
		str_0x = "0x"
	} else {
		for(var j = 0; j < str.length; j++){
			str_0x += str.charCodeAt(j).toString(16)
		}
	}
	return str_0x
}
