pragma solidity ^0.5.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";


// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale { // UPDATE THE CONTRACT SIGNATURE TO ADD INHERITANCE
    
    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        uint256 rate, // rate in TKNbits
        address payable wallet, // sale beneficiary
        KaseiCoin token, // the Kaseicoin itself that the KaseiCoinCrowdsale will work with
        uint goal, // the crowdsale goal
        uint open, // the crowdsale opening time
        uint close // the crowdsale closing time 
        
    ) public
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(open, close)
        RefundableCrowdsale(goal)
    {
        
    }
}


contract KaseiCoinCrowdsaleDeployer {
    // Create an `address public` variable called `kasei_token_address`.
    address public kasei_token_address;
    // Create an `address public` variable called `kasei_crowdsale_address`.
    address public kasei_crowdsale_address;

    // Add the constructor.
    constructor(
       string memory name,
       string memory symbol,
       address payable wallet,
       uint goal
    
    )
        public
    {
        // Create a new instance of the KaseiCoin contract.
        KaseiCoin token = new KaseiCoin(name, symbol, 0);

        
        // Assign the token contract’s address to the `kasei_token_address` variable.
        kasei_token_address = address(token);

        // Create a new instance of the `KaseiCoinCrowdsale` contract
        KaseiCoinCrowdsale kaseicoin_crowdsale = new KaseiCoinCrowdsale(1, wallet, token, goal, now, now + 2 minutes);
            
        // Aassign the `KaseiCoinCrowdsale` contract’s address to the `kasei_crowdsale_address` variable.
        kasei_crowdsale_address = address(kaseicoin_crowdsale);

        // Set the `KaseiCoinCrowdsale` contract as a minter
        token.addMinter(kasei_crowdsale_address);
        
        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }
}
