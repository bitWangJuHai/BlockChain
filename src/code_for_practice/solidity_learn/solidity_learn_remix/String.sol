// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;
contract String {
    string favoriteColor = "blue";

    function showFavoriteColor() public view returns(string memory) {
        return favoriteColor;
    }

    function changeFavoriteColor(string calldata _new) public {
        favoriteColor = _new;
    }

    function getStringLength() public view returns(uint) {
        bytes memory stringToBytes = bytes(favoriteColor);
        return  stringToBytes.length;
    }

}
// var stringContract = new web3.eth.Contract([{"inputs":[{"internalType":"string","name":"_new","type":"string"}],"name":"changeFavoriteColor","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getStringLength","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"showFavoriteColor","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"}]);
// var string = stringContract.deploy({
//      data: '0x60806040526040518060400160405280600481526020017f626c756500000000000000000000000000000000000000000000000000000000815250600090816200004a9190620002d9565b503480156200005857600080fd5b50620003c0565b600081519050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b60006002820490506001821680620000e157607f821691505b602082108103620000f757620000f662000099565b5b50919050565b60008190508160005260206000209050919050565b60006020601f8301049050919050565b600082821b905092915050565b600060088302620001617fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8262000122565b6200016d868362000122565b95508019841693508086168417925050509392505050565b6000819050919050565b6000819050919050565b6000620001ba620001b4620001ae8462000185565b6200018f565b62000185565b9050919050565b6000819050919050565b620001d68362000199565b620001ee620001e582620001c1565b8484546200012f565b825550505050565b600090565b62000205620001f6565b62000212818484620001cb565b505050565b5b818110156200023a576200022e600082620001fb565b60018101905062000218565b5050565b601f82111562000289576200025381620000fd565b6200025e8462000112565b810160208510156200026e578190505b620002866200027d8562000112565b83018262000217565b50505b505050565b600082821c905092915050565b6000620002ae600019846008026200028e565b1980831691505092915050565b6000620002c983836200029b565b9150826002028217905092915050565b620002e4826200005f565b67ffffffffffffffff8111156200030057620002ff6200006a565b5b6200030c8254620000c8565b620003198282856200023e565b600060209050601f8311600181146200035157600084156200033c578287015190505b620003488582620002bb565b865550620003b8565b601f1984166200036186620000fd565b60005b828110156200038b5784890151825560018201915060208501945060208101905062000364565b86831015620003ab5784890151620003a7601f8916826200029b565b8355505b6001600288020188555050505b505050505050565b6106cc80620003d06000396000f3fe608060405234801561001057600080fd5b50600436106100415760003560e01c80637020987914610046578063878209f814610062578063d1cfd04814610080575b600080fd5b610060600480360381019061005b919061024d565b61009e565b005b61006a6100b4565b604051610077919061032a565b60405180910390f35b610088610146565b6040516100959190610365565b60405180910390f35b8181600091826100af9291906105c6565b505050565b6060600080546100c3906103e9565b80601f01602080910402602001604051908101604052809291908181526020018280546100ef906103e9565b801561013c5780601f106101115761010080835404028352916020019161013c565b820191906000526020600020905b81548152906001019060200180831161011f57829003601f168201915b5050505050905090565b60008060008054610156906103e9565b80601f0160208091040260200160405190810160405280929190818152602001828054610182906103e9565b80156101cf5780601f106101a4576101008083540402835291602001916101cf565b820191906000526020600020905b8154815290600101906020018083116101b257829003601f168201915b50505050509050805191505090565b600080fd5b600080fd5b600080fd5b600080fd5b600080fd5b60008083601f84011261020d5761020c6101e8565b5b8235905067ffffffffffffffff81111561022a576102296101ed565b5b602083019150836001820283011115610246576102456101f2565b5b9250929050565b60008060208385031215610264576102636101de565b5b600083013567ffffffffffffffff811115610282576102816101e3565b5b61028e858286016101f7565b92509250509250929050565b600081519050919050565b600082825260208201905092915050565b60005b838110156102d45780820151818401526020810190506102b9565b60008484015250505050565b6000601f19601f8301169050919050565b60006102fc8261029a565b61030681856102a5565b93506103168185602086016102b6565b61031f816102e0565b840191505092915050565b6000602082019050818103600083015261034481846102f1565b905092915050565b6000819050919050565b61035f8161034c565b82525050565b600060208201905061037a6000830184610356565b92915050565b600082905092915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b6000600282049050600182168061040157607f821691505b602082108103610414576104136103ba565b5b50919050565b60008190508160005260206000209050919050565b60006020601f8301049050919050565b600082821b905092915050565b60006008830261047c7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8261043f565b610486868361043f565b95508019841693508086168417925050509392505050565b6000819050919050565b60006104c36104be6104b98461034c565b61049e565b61034c565b9050919050565b6000819050919050565b6104dd836104a8565b6104f16104e9826104ca565b84845461044c565b825550505050565b600090565b6105066104f9565b6105118184846104d4565b505050565b5b818110156105355761052a6000826104fe565b600181019050610517565b5050565b601f82111561057a5761054b8161041a565b6105548461042f565b81016020851015610563578190505b61057761056f8561042f565b830182610516565b50505b505050565b600082821c905092915050565b600061059d6000198460080261057f565b1980831691505092915050565b60006105b6838361058c565b9150826002028217905092915050565b6105d08383610380565b67ffffffffffffffff8111156105e9576105e861038b565b5b6105f382546103e9565b6105fe828285610539565b6000601f83116001811461062d576000841561061b578287013590505b61062585826105aa565b86555061068d565b601f19841661063b8661041a565b60005b828110156106635784890135825560018201915060208501945060208101905061063e565b86831015610680578489013561067c601f89168261058c565b8355505b6001600288020188555050505b5050505050505056fea26469706673582212207cab0ba3628e3fc5aeb9084e0f5d516c35733971686d494b1be4ef4a3ff316ae64736f6c63430008120033', 
//      arguments: [
//      ]
// }).send({
//      from: web3.eth.accounts[0], 
//      gas: '4700000'
//    }, function (e, contract){
//     console.log(e, contract);
//     if (typeof contract.address !== 'undefined') {
//          console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
//     }
//  })