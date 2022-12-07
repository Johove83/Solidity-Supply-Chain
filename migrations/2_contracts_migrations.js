var erc20Token = artifacts.require('./erc20Token.sol');
var SupplyChain = artifacts.require('./supplyChain.sol');

module.exports = function(deployer) {
    deployer.deploy(erc20Token, 10000, 'Aphelion', 18, 'APHL');
    deployer.deploy(SupplyChain);

};