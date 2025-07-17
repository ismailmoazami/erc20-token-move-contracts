
#[test_only]
module erc20_token::erc20_token_tests;

use erc20_token::token::{Self, TOKEN};
use sui::coin::{Coin, TreasuryCap};
use sui::test_scenario::{Self, next_tx, ctx};

#[test]
fun mint_burn_test() {
    let addr = @0xA; 

    let mut scenario = test_scenario::begin(addr);

    {
        token::test_init(scenario.ctx());
    };

    scenario.next_tx(addr); 
    {
        let mut treasury_cap = scenario.take_from_sender<TreasuryCap<TOKEN>>();
        token::mint(&mut treasury_cap, addr, 100, scenario.ctx());
        test_scenario::return_to_address<TreasuryCap<TOKEN>>(
            addr, treasury_cap
        );
    };

    scenario.next_tx(addr);
    {
        let coin = scenario.take_from_sender<Coin<TOKEN>>();
        let mut treasury_cap = scenario.take_from_sender<TreasuryCap<TOKEN>>();
        token::burn(&mut treasury_cap, coin);
        test_scenario::return_to_address<TreasuryCap<TOKEN>>(
            addr, treasury_cap
        );

    };

    scenario.end();
}
