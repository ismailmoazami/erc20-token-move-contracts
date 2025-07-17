module erc20_token::token;

use sui::coin::create_currency;
use sui::coin::{Self, Coin, TreasuryCap};

public struct TOKEN has drop{}

fun init(witness: TOKEN, ctx: &mut TxContext) {
    let name = b"Token"; 
    let symbol = b"TKN"; 
    let decimals = 9; 
    let description = b"An simple ERC20 token";

    let (treasury_cap, token_metadata) = create_currency(
        witness, 
        decimals, 
        symbol, 
        name, 
        description, 
        option::none(), 
        ctx
    );

    sui::transfer::public_freeze_object(token_metadata);
    sui::transfer::public_transfer(treasury_cap, ctx.sender());

}

public fun mint(treasury_cap: &mut TreasuryCap<TOKEN>, to: address, amount: u64, ctx: &mut TxContext) {
    coin::mint_and_transfer(treasury_cap, amount, to, ctx); 
}

public fun burn(treasury_cap: &mut TreasuryCap<TOKEN>, coin: Coin<TOKEN>) {
    coin::burn(treasury_cap, coin); 
}

#[test_only]
public fun test_init(ctx: &mut TxContext) {
    init(TOKEN {}, ctx)
}