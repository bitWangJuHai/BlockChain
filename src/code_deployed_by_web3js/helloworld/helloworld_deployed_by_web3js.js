var solc = require('solc')
var fs = require('fs')
var Web3 = require('web3');

//编译合约
var contractCode = fs.readFileSync("helloworld.sol", "utf-8")
var input = {
    language: 'Solidity',
    sources: {
      'helloworld.sol': {
        content: contractCode
      }
    },
    settings: {
      outputSelection: {
        '*': {
          '*': ['*']
        }
      }
    }
  };
var output = JSON.parse(solc.compile(JSON.stringify(input)))
var helloworld_abi = output.contracts['helloworld.sol']['helloworld'].abi
var helloworld_bytecode = output.contracts['helloworld.sol']['helloworld'].evm.bytecode.object
// 测试编译结果
// console.log(output.contracts)
// for (var contractName in output.contracts['helloworld.sol']) {
//     console.log(
//       contractName +
//         ' contract ABI: ' +
//         JSON.stringify(output.contracts['helloworld.sol'][contractName].abi, null, 2)
//     );
//     console.log(
//         contractName +
//         ' contract byteCode: ' +
//         JSON.stringify(output.contracts['helloworld.sol'][contractName].evm.bytecode.object)
//     )
//     console.log()
// }

//部署及测试合约
var web3 = new Web3('http://127.0.0.1:8545')
var myContract = new web3.eth.Contract(helloworld_abi)
web3.eth.getAccounts().then( accounts => {
  myContract.deploy({
    data: helloworld_bytecode,
    arguments: [
      'helloworld!'
    ]
  })
  .send({
    from: accounts[2],
    gas: 1500000,
    gasPrice: '19904412217'
  }, (err, transactionHash) => {
    if(!err){
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
    result.methods.getContent().call( (err, returnValue) => {
      if( !err ){
        console.log("Call helloworld.getContent() (returnValue: " + returnValue + ")")
      } else {
        console.log("Call helloworld.getContent() Error! " + err)
      }
    })
  })
})
